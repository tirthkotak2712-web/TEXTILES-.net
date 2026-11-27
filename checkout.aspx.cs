using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace textiles
{
    public partial class checkout : Page
    {

        public string GetFirstImage(object val)
        {
            if (val == null || val == DBNull.Value) return "images/product_marble_tshirt.jpg";
            string s = val.ToString().Trim();
            if (string.IsNullOrEmpty(s)) return "images/product_marble_tshirt.jpg";
            string[] parts = s.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length > 0 && !string.IsNullOrWhiteSpace(parts[0]))
                return parts[0].Trim();
            return s;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("login.aspx?returnUrl=checkout.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Auto-fill user details if logged in
                txtEmail.Text = Session["UserEmail"].ToString();
                try
                {
                    string sql = "SELECT TOP 1 name, phone, address FROM users WHERE email=@email";
                    DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@email", Session["UserEmail"].ToString()));
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        txtFullName.Text = dt.Rows[0]["name"].ToString();
                        txtPhone.Text = dt.Rows[0]["phone"].ToString();
                        txtAddress.Text = dt.Rows[0]["address"].ToString();
                        txtCity.Text = "Rajkot";
                        txtState.Text = "Gujarat";
                        txtPincode.Text = "360005";
                    }
                    else
                    {
                        txtCity.Text = "Rajkot";
                        txtState.Text = "Gujarat";
                        txtPincode.Text = "360005";
                    }
                }
                catch
                {
                    txtCity.Text = "Rajkot";
                    txtState.Text = "Gujarat";
                    txtPincode.Text = "360005";
                }

                // Check if coupon is in session
                if (Session["CouponDiscount"] == null)
                {
                    Session["CouponDiscount"] = 0m;
                }

                LoadOrderSummary();
            }
        }

        private void LoadOrderSummary()
        {
            string userEmail = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "guest@textiles.com";
            DataTable dtCart = null;
            try
            {
                string cartSql = "SELECT * FROM cart WHERE user_email=@email";
                dtCart = DbHelper.ExecuteDataTable(cartSql, new SqlParameter("@email", userEmail));
                if ((dtCart == null || dtCart.Rows.Count == 0) && userEmail != "guest@textiles.com")
                {
                    DataTable dtGuest = DbHelper.ExecuteDataTable("SELECT * FROM cart WHERE user_email='guest@textiles.com'");
                    if (dtGuest != null && dtGuest.Rows.Count > 0)
                    {
                        dtCart = dtGuest;
                        DbHelper.ExecuteNonQuery("UPDATE cart SET user_email=@email WHERE user_email='guest@textiles.com'", new SqlParameter("@email", userEmail));
                    }
                }
            }
            catch
            {
            }

            // If empty, redirect to cart page
            if (dtCart == null || dtCart.Rows.Count == 0)
            {
                Response.Redirect("cart.aspx");
                return;
            }

            decimal subtotal = 0;
            foreach (DataRow row in dtCart.Rows)
            {
                subtotal += Convert.ToDecimal(row["price"]) * Convert.ToInt32(row["quantity"]);
            }

            decimal discount = Session["CouponDiscount"] != null ? (decimal)Session["CouponDiscount"] : 0m;
            if (discount > subtotal) discount = subtotal;

            decimal taxable = subtotal - discount;
            decimal tax = Math.Round(taxable * 0.05m);
            decimal total = taxable + tax;

            lblSubtotal.Text = subtotal.ToString("N0");
            lblDiscount.Text = discount.ToString("N0");
            lblTax.Text = tax.ToString("N0");
            lblTotal.Text = total.ToString("N0");

            btnPlaceOrder.Text = "Place Order — Pay \u20B9" + total.ToString("N0") + " on Delivery (COD)";

            rptCheckoutItems.DataSource = dtCart;
            rptCheckoutItems.DataBind();
        }

        protected void btnApplyCoupon_Click(object sender, EventArgs e)
        {
            string code = txtCoupon.Text.Trim().ToUpper();
            if (string.IsNullOrEmpty(code))
            {
                Session["CouponDiscount"] = 0m;
                lblCouponMsg.Text = "Please enter a valid coupon code.";
                lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(211, 47, 47);
                lblCouponMsg.Visible = true;
                LoadOrderSummary();
                return;
            }

            try
            {
                decimal subtotal = 0m;
                decimal.TryParse(lblSubtotal.Text.Replace(",", ""), out subtotal);
                if (subtotal <= 0) subtotal = 799m;

                string sql = "SELECT TOP 1 * FROM coupons WHERE UPPER(code)=@code AND status='Active' AND (expiry_date IS NULL OR expiry_date >= CAST(GETDATE() AS DATE))";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@code", code));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string type = r["discount_type"] != DBNull.Value ? r["discount_type"].ToString() : "Percentage";
                    decimal val = r["discount_value"] != DBNull.Value ? Convert.ToDecimal(r["discount_value"]) : 0m;
                    decimal minOrder = r["min_order"] != DBNull.Value ? Convert.ToDecimal(r["min_order"]) : 0m;

                    if (subtotal < minOrder)
                    {
                        Session["CouponDiscount"] = 0m;
                        lblCouponMsg.Text = "Minimum order of \u20B9" + minOrder.ToString("N0") + " required for coupon " + code + ".";
                        lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(211, 47, 47);
                    }
                    else
                    {
                        decimal discount = 0m;
                        if (type.Equals("Percentage", StringComparison.OrdinalIgnoreCase))
                        {
                            discount = Math.Round(subtotal * (val / 100m));
                        }
                        else
                        {
                            discount = val;
                        }
                        if (discount > subtotal) discount = subtotal;

                        Session["CouponDiscount"] = discount;
                        lblCouponMsg.Text = "\u2713 Coupon \"" + code + "\" applied! You saved \u20B9" + discount.ToString("N0") + ".";
                        lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(46, 125, 50);
                    }
                }
                else if (code == "TEXTILES10" || code == "WELCOME10")
                {
                    decimal discount = Math.Round(subtotal * 0.10m);
                    Session["CouponDiscount"] = discount;
                    lblCouponMsg.Text = "\u2713 Coupon \"" + code + "\" applied! You saved \u20B9" + discount.ToString("N0") + ".";
                    lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(46, 125, 50);
                }
                else
                {
                    Session["CouponDiscount"] = 0m;
                    lblCouponMsg.Text = "Invalid or expired coupon code.";
                    lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(211, 47, 47);
                }
            }
            catch (Exception ex)
            {
                lblCouponMsg.Text = "Error applying coupon: " + ex.Message;
                lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(211, 47, 47);
            }

            lblCouponMsg.Visible = true;
            LoadOrderSummary();
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim() + ", " + txtCity.Text.Trim() + ", " + txtState.Text.Trim() + " - " + txtPincode.Text.Trim();
            string payMethodDisplay = "Cash on Delivery (COD)";
            string payStatus = "Pending";

            string userEmail = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : (!string.IsNullOrEmpty(email) ? email : "guest@textiles.com");

            try
            {
                // Generate order number like Figure 10: ORD-FWQ3H
                string orderNumber = "ORD-" + Guid.NewGuid().ToString("N").Substring(0, 5).ToUpper();

                // Fetch cart items
                string cartSql = "SELECT * FROM cart WHERE user_email=@email";
                DataTable dtCart = DbHelper.ExecuteDataTable(cartSql, new SqlParameter("@email", userEmail));

                // If no items found for this email, check guest cart or session email
                if (dtCart == null || dtCart.Rows.Count == 0)
                {
                    if (userEmail != "guest@textiles.com")
                    {
                        dtCart = DbHelper.ExecuteDataTable("SELECT * FROM cart WHERE user_email='guest@textiles.com'");
                    }
                    if ((dtCart == null || dtCart.Rows.Count == 0) && !string.IsNullOrEmpty(email) && email != userEmail)
                    {
                        dtCart = DbHelper.ExecuteDataTable("SELECT * FROM cart WHERE user_email=@email", new SqlParameter("@email", email));
                    }
                    if ((dtCart == null || dtCart.Rows.Count == 0) && Session["UserEmail"] != null && Session["UserEmail"].ToString() != userEmail)
                    {
                        dtCart = DbHelper.ExecuteDataTable("SELECT * FROM cart WHERE user_email=@email", new SqlParameter("@email", Session["UserEmail"].ToString()));
                    }
                }

                if (dtCart == null || dtCart.Rows.Count == 0)
                {
                    lblCheckoutMsg.Text = "Your cart is empty. Please add items to your cart before placing an order.";
                    lblCheckoutMsg.Visible = true;
                    return;
                }

                decimal subtotal = 0m;
                foreach (DataRow row in dtCart.Rows)
                {
                    subtotal += Convert.ToDecimal(row["price"]) * Convert.ToInt32(row["quantity"]);
                }

                decimal discount = Session["CouponDiscount"] != null ? Convert.ToDecimal(Session["CouponDiscount"]) : 0m;
                if (discount > subtotal) discount = subtotal;

                decimal taxable = subtotal - discount;
                decimal tax = (taxable <= 0m) ? 0m : Math.Round(taxable * 0.05m);
                decimal totalAmount = taxable + tax;
                if (totalAmount < 0m) totalAmount = 0m;

                // Validate size-specific stock and active status before placing order
                if (dtCart != null && dtCart.Rows.Count > 0)
                {
                    foreach (DataRow row in dtCart.Rows)
                    {
                        if (row["product_id"] != DBNull.Value)
                        {
                            int checkPid = Convert.ToInt32(row["product_id"]);
                            int reqQty = Convert.ToInt32(row["quantity"]);
                            string itemName = row["product_name"].ToString();
                            string itemSize = row["size"] != DBNull.Value ? row["size"].ToString().ToUpper() : "M";

                            DataTable dtProd = DbHelper.ExecuteDataTable(@"
                                SELECT stock, 
                                       ISNULL(stock_s, 0) as stock_s, 
                                       ISNULL(stock_m, 0) as stock_m, 
                                       ISNULL(stock_l, 0) as stock_l, 
                                       ISNULL(stock_xl, 0) as stock_xl, 
                                       ISNULL(stock_xxl, 0) as stock_xxl, 
                                       ISNULL(is_active, 1) as is_active 
                                FROM products 
                                WHERE id=@pid", new SqlParameter("@pid", checkPid));

                            if (dtProd != null && dtProd.Rows.Count > 0)
                            {
                                int curActive = Convert.ToInt32(dtProd.Rows[0]["is_active"]);
                                int sizeStock = 0;
                                switch (itemSize)
                                {
                                    case "S": sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock_s"]); break;
                                    case "M": sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock_m"]); break;
                                    case "L": sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock_l"]); break;
                                    case "XL": sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock_xl"]); break;
                                    case "XXL": sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock_xxl"]); break;
                                    default: sizeStock = Convert.ToInt32(dtProd.Rows[0]["stock"]); break;
                                }

                                if (curActive == 0 || sizeStock <= 0 || reqQty > sizeStock)
                                {
                                    lblCouponMsg.Text = $"Product '{itemName}' (Size {itemSize}) only has {sizeStock} unit(s) available in stock. You requested {reqQty}. Please adjust your cart.";
                                    lblCouponMsg.ForeColor = System.Drawing.Color.FromArgb(211, 47, 47);
                                    lblCouponMsg.Visible = true;
                                    LoadOrderSummary();
                                    return;
                                }
                            }
                        }
                    }
                }

                string insertOrderSql = @"
                    INSERT INTO orders (order_number, user_email, customer_name, phone, address, total_amount, payment_method, payment_status, order_status, created_at)
                    OUTPUT INSERTED.id
                    VALUES (@orderNum, @email, @name, @phone, @address, @amount, @method, @payStatus, 'Processing', GETDATE())";

                object orderIdObj = DbHelper.ExecuteScalar(insertOrderSql,
                    new SqlParameter("@orderNum", orderNumber),
                    new SqlParameter("@email", userEmail),
                    new SqlParameter("@name", fullName),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@address", address),
                    new SqlParameter("@amount", totalAmount),
                    new SqlParameter("@method", payMethodDisplay),
                    new SqlParameter("@payStatus", payStatus));

                int newOrderId = orderIdObj != null ? Convert.ToInt32(orderIdObj) : 0;

                // Move items from cart to order_items AND MINUS STOCK FROM PRODUCTS
                if (dtCart != null && dtCart.Rows.Count > 0 && newOrderId > 0)
                {
                    foreach (DataRow row in dtCart.Rows)
                    {
                        int pId = Convert.ToInt32(row["product_id"]);
                        string pName = row["product_name"].ToString();
                        decimal pPrice = Convert.ToDecimal(row["price"]);
                        int pQty = Convert.ToInt32(row["quantity"]);
                        string pSize = row["size"].ToString();
                        decimal pTotal = pPrice * pQty;

                        // Insert into order_items
                        string itemSql = "INSERT INTO order_items (order_id, product_id, product_name, price, quantity, size, total) VALUES (@oid, @pid, @name, @price, @qty, @size, @total)";
                        DbHelper.ExecuteNonQuery(itemSql,
                            new SqlParameter("@oid", newOrderId),
                            new SqlParameter("@pid", pId),
                            new SqlParameter("@name", pName),
                            new SqlParameter("@price", pPrice),
                            new SqlParameter("@qty", pQty),
                            new SqlParameter("@size", pSize),
                            new SqlParameter("@total", pTotal));

                        // 4. MINUS PRODUCT IN SIZE-SPECIFIC STOCK AND TOTAL STOCK UPON PURCHASE
                        if (pId > 0)
                        {
                            string deductStockSql = @"
                                UPDATE products 
                                SET 
                                    stock_s = CASE WHEN @size = 'S' THEN (CASE WHEN stock_s >= @qty THEN stock_s - @qty ELSE 0 END) ELSE stock_s END,
                                    stock_m = CASE WHEN @size = 'M' THEN (CASE WHEN stock_m >= @qty THEN stock_m - @qty ELSE 0 END) ELSE stock_m END,
                                    stock_l = CASE WHEN @size = 'L' THEN (CASE WHEN stock_l >= @qty THEN stock_l - @qty ELSE 0 END) ELSE stock_l END,
                                    stock_xl = CASE WHEN @size = 'XL' THEN (CASE WHEN stock_xl >= @qty THEN stock_xl - @qty ELSE 0 END) ELSE stock_xl END,
                                    stock_xxl = CASE WHEN @size = 'XXL' THEN (CASE WHEN stock_xxl >= @qty THEN stock_xxl - @qty ELSE 0 END) ELSE stock_xxl END,
                                    stock = CASE WHEN stock >= @qty THEN stock - @qty ELSE 0 END
                                WHERE id = @pid";
                            DbHelper.ExecuteNonQuery(deductStockSql,
                                new SqlParameter("@qty", pQty),
                                new SqlParameter("@size", pSize.ToUpper()),
                                new SqlParameter("@pid", pId));
                        }
                        else if (!string.IsNullOrEmpty(pName))
                        {
                            string deductStockSql = @"
                                UPDATE products 
                                SET 
                                    stock_s = CASE WHEN @size = 'S' THEN (CASE WHEN stock_s >= @qty THEN stock_s - @qty ELSE 0 END) ELSE stock_s END,
                                    stock_m = CASE WHEN @size = 'M' THEN (CASE WHEN stock_m >= @qty THEN stock_m - @qty ELSE 0 END) ELSE stock_m END,
                                    stock_l = CASE WHEN @size = 'L' THEN (CASE WHEN stock_l >= @qty THEN stock_l - @qty ELSE 0 END) ELSE stock_l END,
                                    stock_xl = CASE WHEN @size = 'XL' THEN (CASE WHEN stock_xl >= @qty THEN stock_xl - @qty ELSE 0 END) ELSE stock_xl END,
                                    stock_xxl = CASE WHEN @size = 'XXL' THEN (CASE WHEN stock_xxl >= @qty THEN stock_xxl - @qty ELSE 0 END) ELSE stock_xxl END,
                                    stock = CASE WHEN stock >= @qty THEN stock - @qty ELSE 0 END
                                WHERE name = @pname";
                            DbHelper.ExecuteNonQuery(deductStockSql,
                                new SqlParameter("@qty", pQty),
                                new SqlParameter("@size", pSize.ToUpper()),
                                new SqlParameter("@pname", pName));
                        }
                    }

                    // Clear cart for this user and guest
                    DbHelper.ExecuteNonQuery("DELETE FROM cart WHERE user_email=@email OR user_email='guest@textiles.com'", new SqlParameter("@email", userEmail));
                    if (!string.IsNullOrEmpty(email) && email != userEmail)
                    {
                        DbHelper.ExecuteNonQuery("DELETE FROM cart WHERE user_email=@email", new SqlParameter("@email", email));
                    }
                }

                // Reset applied coupon
                Session["CouponDiscount"] = null;

                // Store details in session for processing & success pages
                Session["LastOrderNumber"] = orderNumber;
                Session["LastCustomerName"] = fullName;
                Session["LastCustomerEmail"] = email;
                Session["LastCustomerPhone"] = phone;
                Session["LastOrderAddress"] = address;
                Session["LastOrderAmount"] = totalAmount.ToString("N0");
                Session["LastPaymentMethod"] = payMethodDisplay;
                Session["LastPaymentId"] = "COD-" + orderNumber;

                // Redirect to Success page with instant Order Done Animation!
                Response.Redirect("success.aspx?order=" + Server.UrlEncode(orderNumber));
            }
            catch (Exception ex)
            {
                lblCheckoutMsg.Text = "Error placing order: " + ex.Message;
                lblCheckoutMsg.Visible = true;
            }
        }
    }
}