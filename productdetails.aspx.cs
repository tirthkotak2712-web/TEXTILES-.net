using System;
using System.Data;
using System.Web.UI;
using System.Data.SqlClient;

namespace textiles
{
    public partial class productdetails : Page
    {
        private int productId = 1;

        public int SizeStockS { get; set; } = 0;
        public int SizeStockM { get; set; } = 0;
        public int SizeStockL { get; set; } = 0;
        public int SizeStockXL { get; set; } = 0;
        public int SizeStockXXL { get; set; } = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["id"] != null)
            {
                int.TryParse(Request.QueryString["id"], out productId);
            }
            if (productId <= 0) productId = 1;

            if (!IsPostBack)
            {
                LoadProductDetails();
            }
        }

        public string GetStarsHtml(object val)
        {
            if (val == null || val == DBNull.Value) return "";
            decimal r = 5.0m;
            decimal.TryParse(val.ToString(), out r);
            int fullStars = (int)Math.Floor(r);
            bool hasHalf = (r - fullStars) >= 0.4m;
            string html = "";
            for (int i = 0; i < fullStars && i < 5; i++)
                html += "<i class=\"fa-solid fa-star\"></i> ";
            if (hasHalf && fullStars < 5)
                html += "<i class=\"fa-solid fa-star-half-stroke\"></i> ";
            int emptyStars = 5 - fullStars - (hasHalf ? 1 : 0);
            for (int i = 0; i < emptyStars; i++)
                html += "<i class=\"fa-regular fa-star\" style=\"color:#cbd5e1;\"></i> ";
            return html + $" <strong style=\"color:#1e293b; font-size:13px; margin-left:4px;\">{r:0.0}</strong>";
        }

        private void LoadProductDetails()
        {
            try
            {
                string sql = "SELECT TOP 1 * FROM products WHERE id=@id";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@id", productId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string pName = row["name"].ToString();
                    lblTitle.Text = pName;
                    lblCategory.Text = row["category"].ToString().ToUpper();
                    lblPrice.Text = Convert.ToDecimal(row["price"]).ToString("N0");
                    lblOriginalPrice.Text = Convert.ToDecimal(row["original_price"]).ToString("N0");
                    lblDescription.Text = row["description"].ToString();

                    int stock = row["stock"] != DBNull.Value ? Convert.ToInt32(row["stock"]) : 0;
                    int isActive = row.Table.Columns.Contains("is_active") && row["is_active"] != DBNull.Value ? Convert.ToInt32(row["is_active"]) : 1;

                    SizeStockS = row.Table.Columns.Contains("stock_s") && row["stock_s"] != DBNull.Value ? Convert.ToInt32(row["stock_s"]) : Math.Max(0, stock * 15 / 100);
                    SizeStockM = row.Table.Columns.Contains("stock_m") && row["stock_m"] != DBNull.Value ? Convert.ToInt32(row["stock_m"]) : Math.Max(0, stock * 30 / 100);
                    SizeStockL = row.Table.Columns.Contains("stock_l") && row["stock_l"] != DBNull.Value ? Convert.ToInt32(row["stock_l"]) : Math.Max(0, stock * 30 / 100);
                    SizeStockXL = row.Table.Columns.Contains("stock_xl") && row["stock_xl"] != DBNull.Value ? Convert.ToInt32(row["stock_xl"]) : Math.Max(0, stock * 15 / 100);
                    SizeStockXXL = row.Table.Columns.Contains("stock_xxl") && row["stock_xxl"] != DBNull.Value ? Convert.ToInt32(row["stock_xxl"]) : Math.Max(0, stock - (SizeStockS + SizeStockM + SizeStockL + SizeStockXL));

                    // STOCK & ACTIVE STATUS (PROBLEMS 2 & 3)
                    if (isActive == 0)
                    {
                        litStockStatus.Text = "<span style=\"color:#ef4444; font-weight:700;\"><i class=\"fa-solid fa-circle-xmark\"></i> Inactive (Currently Unavailable)</span>";
                        btnAddToCart.Enabled = false;
                        btnAddToCart.CssClass = "btn-add-cart disabled";
                        btnAddToCart.Text = "Unavailable";
                        btnBuyNow.Enabled = false;
                        btnBuyNow.CssClass = "btn-buy-now disabled";
                        btnBuyNow.Text = "Unavailable";
                    }
                    else if (stock <= 0)
                    {
                        litStockStatus.Text = "<span style=\"color:#ef4444; font-weight:700;\"><i class=\"fa-solid fa-circle-xmark\"></i> Out of Stock</span>";
                        btnAddToCart.Enabled = false;
                        btnAddToCart.CssClass = "btn-add-cart disabled";
                        btnAddToCart.Text = "Out of Stock";
                        btnBuyNow.Enabled = false;
                        btnBuyNow.CssClass = "btn-buy-now disabled";
                        btnBuyNow.Text = "Out of Stock";
                    }
                    else
                    {
                        litStockStatus.Text = $"<span style=\"color:#16a34a; font-weight:700;\"><i class=\"fa-solid fa-circle-check\"></i> In Stock ({stock} units available)</span>";
                        btnAddToCart.Enabled = true;
                        btnAddToCart.CssClass = "btn-add-cart";
                        btnAddToCart.Text = "Add to Cart";
                        btnBuyNow.Enabled = true;
                        btnBuyNow.CssClass = "btn-buy-now";
                        btnBuyNow.Text = "Buy Now";
                    }

                    // DYNAMIC REVIEWS & AVERAGE RATING (PROBLEM 1)
                    DataTable dtReviews = DbHelper.ExecuteDataTable(
                        "SELECT customer_name, rating, comment, created_at FROM reviews WHERE product_name = @pname OR product_id = @pid ORDER BY id DESC",
                        new SqlParameter("@pname", pName),
                        new SqlParameter("@pid", productId));

                    if (dtReviews != null && dtReviews.Rows.Count > 0)
                    {
                        decimal totalRating = 0;
                        foreach (DataRow r in dtReviews.Rows)
                        {
                            totalRating += Convert.ToDecimal(r["rating"]);
                        }
                        decimal avgRating = Math.Round(totalRating / dtReviews.Rows.Count, 1);
                        lblRating.Text = avgRating.ToString("0.0");
                        lblReviewsCount.Text = $"({dtReviews.Rows.Count} customer review{(dtReviews.Rows.Count > 1 ? "s" : "")})";
                        rptProductReviews.DataSource = dtReviews;
                        rptProductReviews.DataBind();
                        pnlReviewsSection.Visible = true;
                    }
                    else
                    {
                        lblRating.Text = row["rating"] != DBNull.Value ? Convert.ToDecimal(row["rating"]).ToString("0.0") : "4.8";
                        lblReviewsCount.Text = "(0 customer reviews)";
                        pnlReviewsSection.Visible = false;
                    }

                    // IMAGES (UP TO 5)
                    string rawImg = row["image_url"] != null ? row["image_url"].ToString() : "";
                    var imgList = new System.Collections.Generic.List<string>();
                    if (!string.IsNullOrEmpty(rawImg))
                    {
                        string[] parts = rawImg.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                        for (int i = 0; i < parts.Length && imgList.Count < 5; i++)
                        {
                            string p = parts[i].Trim();
                            if (!string.IsNullOrEmpty(p)) imgList.Add(p);
                        }
                    }
                    if (imgList.Count == 0)
                    {
                        imgList.Add("images/product_marble_tshirt.jpg");
                    }

                    imgProduct.ImageUrl = imgList[0];
                    rptThumbnails.DataSource = imgList;
                    rptThumbnails.DataBind();
                    thumbnailsContainer.Visible = (imgList.Count > 1);
                    return;
                }
            }
            catch
            {
                // Fallback to static wireframe data
            }

            LoadStaticProductDetails(productId);
        }

        private void LoadStaticProductDetails(int id)
        {
            switch (id)
            {
                case 2:
                    lblTitle.Text = "Gorilla Graphic T-Shirt";
                    lblCategory.Text = "T-SHIRTS";
                    lblPrice.Text = "849";
                    lblOriginalPrice.Text = "1,299";
                    lblRating.Text = "4.7";
                    lblDescription.Text = "Streetwear aesthetic oversized graphic t-shirt with vivid gorilla artwork. 100% bio-washed cotton.";
                    imgProduct.ImageUrl = "images/product_gorilla_tshirt.jpg";
                    break;
                case 3:
                    lblTitle.Text = "Textiles Signature Hoodie";
                    lblCategory.Text = "HOODIES";
                    lblPrice.Text = "1,599";
                    lblOriginalPrice.Text = "2,299";
                    lblRating.Text = "4.9";
                    lblDescription.Text = "Heavy-blend fleece pullover hoodie with signature Textiles embroidery, double-lined hood, and kangaroo pouch.";
                    imgProduct.ImageUrl = "images/product_textiles_hoodie.jpg";
                    break;
                case 4:
                    lblTitle.Text = "Tiger Varsity Jacket";
                    lblCategory.Text = "JACKETS";
                    lblPrice.Text = "2,499";
                    lblOriginalPrice.Text = "3,499";
                    lblRating.Text = "4.8";
                    lblDescription.Text = "Retro varsity bomber jacket with embroidered tiger back emblem, contrast striped ribbing, and snap-button closure.";
                    imgProduct.ImageUrl = "images/product_tiger_jacket.jpg";
                    break;
                case 5:
                    lblTitle.Text = "Slim Fit Blue Jeans";
                    lblCategory.Text = "JEANS";
                    lblPrice.Text = "1,299";
                    lblOriginalPrice.Text = "1,899";
                    lblRating.Text = "4.6";
                    lblDescription.Text = "Classic washed indigo slim fit denim jeans crafted from stretch cotton with clean five-pocket detailing.";
                    imgProduct.ImageUrl = "images/product_slim_jeans.jpg";
                    break;
                default:
                    lblTitle.Text = "Marble Swirl Print T-Shirt";
                    lblCategory.Text = "T-SHIRTS";
                    lblPrice.Text = "799";
                    lblOriginalPrice.Text = "1,199";
                    lblRating.Text = "4.8";
                    lblDescription.Text = "Premium combed cotton t-shirt featuring modern marble swirl print. Super comfortable, breathable, and pre-shrunk for an ideal fit.";
                    imgProduct.ImageUrl = "images/product_marble_tshirt.jpg";
                    break;
            }

            SizeStockS = 7; SizeStockM = 15; SizeStockL = 15; SizeStockXL = 7; SizeStockXXL = 6;
            var defaultList = new System.Collections.Generic.List<string> { imgProduct.ImageUrl };
            rptThumbnails.DataSource = defaultList;
            rptThumbnails.DataBind();
            thumbnailsContainer.Visible = false;
        }

        protected void btnAddToCart_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            AddToCartAndRedirect("cart.aspx");
        }

        protected void btnBuyNow_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;
            AddToCartAndRedirect("checkout.aspx");
        }

        private void AddToCartAndRedirect(string redirectPage)
        {
            if (!Page.IsValid) return;

            if (Session["UserEmail"] == null)
            {
                Response.Redirect("login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            string userEmail = Session["UserEmail"].ToString();
            int qty = 1;
            int.TryParse(txtQuantity.Text, out qty);
            if (qty < 1) qty = 1;
            string selectedSize = ddlSize.SelectedValue.ToUpper();

            try
            {
                string sql = "SELECT TOP 1 * FROM products WHERE id=@id";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@id", productId));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    int stock = row["stock"] != DBNull.Value ? Convert.ToInt32(row["stock"]) : 0;
                    int isActive = row.Table.Columns.Contains("is_active") && row["is_active"] != DBNull.Value ? Convert.ToInt32(row["is_active"]) : 1;

                    if (isActive == 0 || stock <= 0)
                    {
                        lblProductMsg.Text = "<div style=\"color:#b91c1c; background:#fef2f2; border:1px solid #fecaca; padding:10px 14px; border-radius:8px; margin-bottom:15px; font-weight:600;\">Sorry, this product is currently unavailable or out of stock.</div>";
                        lblProductMsg.Visible = true;
                        return;
                    }

                    int sizeStock = 0;
                    switch (selectedSize)
                    {
                        case "S": sizeStock = row.Table.Columns.Contains("stock_s") && row["stock_s"] != DBNull.Value ? Convert.ToInt32(row["stock_s"]) : 0; break;
                        case "M": sizeStock = row.Table.Columns.Contains("stock_m") && row["stock_m"] != DBNull.Value ? Convert.ToInt32(row["stock_m"]) : 0; break;
                        case "L": sizeStock = row.Table.Columns.Contains("stock_l") && row["stock_l"] != DBNull.Value ? Convert.ToInt32(row["stock_l"]) : 0; break;
                        case "XL": sizeStock = row.Table.Columns.Contains("stock_xl") && row["stock_xl"] != DBNull.Value ? Convert.ToInt32(row["stock_xl"]) : 0; break;
                        case "XXL": sizeStock = row.Table.Columns.Contains("stock_xxl") && row["stock_xxl"] != DBNull.Value ? Convert.ToInt32(row["stock_xxl"]) : 0; break;
                        default: sizeStock = stock; break;
                    }

                    if (sizeStock <= 0)
                    {
                        lblProductMsg.Text = $"<div style=\"color:#b91c1c; background:#fef2f2; border:1px solid #fecaca; padding:10px 14px; border-radius:8px; margin-bottom:15px; font-weight:600;\">Sorry, Size {selectedSize} is completely out of stock!</div>";
                        lblProductMsg.Visible = true;
                        return;
                    }

                    string pName = row["name"].ToString();
                    decimal pPrice = Convert.ToDecimal(row["price"]);
                    string pImage = row["image_url"].ToString();

                    string checkSql = "SELECT TOP 1 id, quantity FROM cart WHERE user_email=@email AND product_id=@pid AND size=@size";
                    DataTable dtCart = DbHelper.ExecuteDataTable(checkSql, 
                        new SqlParameter("@email", userEmail),
                        new SqlParameter("@pid", productId),
                        new SqlParameter("@size", selectedSize));

                    int currentQty = 0;
                    int cartId = 0;
                    if (dtCart != null && dtCart.Rows.Count > 0)
                    {
                        cartId = Convert.ToInt32(dtCart.Rows[0]["id"]);
                        currentQty = Convert.ToInt32(dtCart.Rows[0]["quantity"]);
                    }

                    if (currentQty + qty > sizeStock)
                    {
                        int remaining = sizeStock - currentQty;
                        if (remaining <= 0)
                        {
                            lblProductMsg.Text = $"<div style=\"color:#b91c1c; background:#fef2f2; border:1px solid #fecaca; padding:10px 14px; border-radius:8px; margin-bottom:15px; font-weight:600;\">Cannot add to cart. You already have {currentQty} item(s) of Size {selectedSize} in your cart, which is the total stock available ({sizeStock} units).</div>";
                        }
                        else
                        {
                            lblProductMsg.Text = $"<div style=\"color:#b91c1c; background:#fef2f2; border:1px solid #fecaca; padding:10px 14px; border-radius:8px; margin-bottom:15px; font-weight:600;\">Cannot add {qty} item(s). Only {sizeStock} units in stock for Size {selectedSize}. You have {currentQty} in cart, so you can only add up to {remaining} more unit(s).</div>";
                        }
                        lblProductMsg.Visible = true;
                        return;
                    }

                    if (cartId > 0)
                    {
                        string updateSql = "UPDATE cart SET quantity=@qty WHERE id=@cid";
                        DbHelper.ExecuteNonQuery(updateSql, 
                            new SqlParameter("@qty", currentQty + qty),
                            new SqlParameter("@cid", cartId));
                    }
                    else
                    {
                        string insertSql = "INSERT INTO cart (user_email, product_id, product_name, price, image_url, quantity, size) VALUES (@email, @pid, @pname, @price, @image, @qty, @size)";
                        DbHelper.ExecuteNonQuery(insertSql,
                            new SqlParameter("@email", userEmail),
                            new SqlParameter("@pid", productId),
                            new SqlParameter("@pname", pName),
                            new SqlParameter("@price", pPrice),
                            new SqlParameter("@image", pImage),
                            new SqlParameter("@qty", qty),
                            new SqlParameter("@size", selectedSize));
                    }
                }
            }
            catch
            {
                // Ignored fallback
            }

            Response.Redirect(redirectPage);
        }

        protected void btnAddToWishlist_Click(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                int pid = 1;
                int.TryParse(Request.QueryString["id"], out pid);
                Response.Redirect("login.aspx?returnUrl=" + Server.UrlEncode("productdetails.aspx?id=" + pid));
                return;
            }

            int productId;
            if (!int.TryParse(Request.QueryString["id"], out productId))
            {
                productId = 1;
            }

            string userEmail = Session["UserEmail"].ToString();

            try
            {
                string checkSql = "SELECT COUNT(*) FROM wishlist WHERE user_email=@email AND product_id=@pid";
                int exists = Convert.ToInt32(DbHelper.ExecuteScalar(checkSql,
                    new SqlParameter("@email", userEmail),
                    new SqlParameter("@pid", productId)));

                if (exists == 0)
                {
                    string prodSql = "SELECT TOP 1 name, price, image_url FROM products WHERE id=@id";
                    DataTable dtProd = DbHelper.ExecuteDataTable(prodSql, new SqlParameter("@id", productId));
                    if (dtProd != null && dtProd.Rows.Count > 0)
                    {
                        string pName = dtProd.Rows[0]["name"].ToString();
                        decimal price = Convert.ToDecimal(dtProd.Rows[0]["price"]);
                        string img = dtProd.Rows[0]["image_url"].ToString();

                        string insertSql = @"INSERT INTO wishlist (user_email, product_id, product_name, price, image_url) 
                                             VALUES (@email, @pid, @name, @price, @img)";
                        DbHelper.ExecuteNonQuery(insertSql,
                            new SqlParameter("@email", userEmail),
                            new SqlParameter("@pid", productId),
                            new SqlParameter("@name", pName),
                            new SqlParameter("@price", price),
                            new SqlParameter("@img", img));

                        lblWishlistStatus.Text = "<span style=\"color:#15803d; background:#dcfce7; border:1px solid #bbf7d0; display:block; padding:8px 12px; border-radius:6px;\"><i class=\"fa-solid fa-circle-check\"></i> Added to your Wishlist! <a href=\"wishlist.aspx\" style=\"color:#15803d; font-weight:700; margin-left:6px; text-decoration:underline;\">View Wishlist</a></span>";
                        lblWishlistStatus.Visible = true;
                    }
                }
                else
                {
                    lblWishlistStatus.Text = "<span style=\"color:#0369a1; background:#e0f2fe; border:1px solid #bae6fd; display:block; padding:8px 12px; border-radius:6px;\"><i class=\"fa-solid fa-circle-info\"></i> This product is already in your Wishlist. <a href=\"wishlist.aspx\" style=\"color:#0369a1; font-weight:700; margin-left:6px; text-decoration:underline;\">View Wishlist</a></span>";
                    lblWishlistStatus.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblWishlistStatus.Text = "<span style=\"color:#b91c1c; background:#fee2e2; border:1px solid #fecaca; display:block; padding:8px 12px; border-radius:6px;\">Error: " + Server.HtmlEncode(ex.Message) + "</span>";
                lblWishlistStatus.Visible = true;
            }
        }
    }
}