using System;
using System.Data;
using System.Web.UI;
using System.Data.SqlClient;

namespace textiles
{
    public partial class profile : Page
    {
        public string CleanJs(object val)
        {
            if (val == null || val == DBNull.Value) return "";
            return val.ToString()
                      .Replace("\\", "\\\\")
                      .Replace("'", "\\'")
                      .Replace("\"", "&quot;")
                      .Replace("\r", "")
                      .Replace("\n", " ");
        }

        public bool IsOrderDelivered(object statusVal)
        {
            if (statusVal == null || statusVal == DBNull.Value) return false;
            string s = statusVal.ToString().Trim();
            return s.Equals("Delivered", StringComparison.OrdinalIgnoreCase) ||
                   s.Equals("Completed", StringComparison.OrdinalIgnoreCase);
        }

        public string GetReturnButtonOrBadge(object orderNumberObj, object orderIdObj, object prodNamesObj, object totalAmountObj, object statusVal, object returnStatusVal)
        {
            if (!IsOrderDelivered(statusVal)) return "";
            string retStatus = returnStatusVal != null && returnStatusVal != DBNull.Value ? returnStatusVal.ToString().Trim() : "None";
            if (string.IsNullOrEmpty(retStatus)) retStatus = "None";

            string ordNum = orderNumberObj != null ? orderNumberObj.ToString() : "";
            string ordId = orderIdObj != null ? orderIdObj.ToString() : "0";
            string prods = prodNamesObj != null ? CleanJs(prodNamesObj) : "Garment Item";
            string amount = totalAmountObj != null ? String.Format("{0:N0}", totalAmountObj) : "0";

            switch (retStatus.ToLower())
            {
                case "pending":
                    return "<span class=\"badge-return return-pending\" title=\"Return request submitted & under review\"><i class=\"fa-solid fa-clock-rotate-left\"></i> Return Pending</span>";
                case "approved":
                    return "<span class=\"badge-return return-approved\" title=\"Return approved by store administration\"><i class=\"fa-solid fa-circle-check\"></i> Return Approved</span>";
                case "rejected":
                    return "<span class=\"badge-return return-rejected\" title=\"Return request rejected\"><i class=\"fa-solid fa-circle-xmark\"></i> Return Rejected</span>";
                case "completed":
                    return "<span class=\"badge-return return-completed\" title=\"Returned & refunded successfully\"><i class=\"fa-solid fa-box-archive\"></i> Returned &amp; Refunded</span>";
                default:
                    return $"<button type=\"button\" class=\"btn-return-order\" onclick=\"openReturnModal('{ordNum}', '{ordId}', '{prods}', '{amount}')\"><i class=\"fa-solid fa-rotate-left\"></i> Return</button>";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            pnlAlert.Visible = false;

            if (!IsPostBack)
            {
                hfActiveTab.Value = "dashboard";
                LoadUserData();
                LoadUserOrders();
            }
        }

        private void LoadUserData()
        {
            string email = Session["UserEmail"].ToString();
            lblProfileEmail.Text = email;
            txtEmail.Text = email;

            try
            {
                string sql = "SELECT TOP 1 name, email, phone, address FROM users WHERE email=@email";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@email", email));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string fullName = row["name"] != DBNull.Value ? row["name"].ToString() : "User";
                    lblProfileName.Text = fullName;

                    // Split into first and last name
                    string[] parts = fullName.Split(new char[] { ' ' }, 2, StringSplitOptions.RemoveEmptyEntries);
                    txtFirstName.Text = parts.Length > 0 ? parts[0] : "";
                    txtLastName.Text = parts.Length > 1 ? parts[1] : "";

                    txtPhone.Text = row["phone"] != DBNull.Value ? row["phone"].ToString() : "";

                    string address = row["address"] != DBNull.Value ? row["address"].ToString() : "";
                    if (!string.IsNullOrWhiteSpace(address))
                    {
                        txtAddressLine.Text = address;
                        lblDisplayAddress.Text = Server.HtmlEncode(address);
                    }
                    else
                    {
                        lblDisplayAddress.Text = "No default delivery address set yet. Please add your address below.";
                    }
                }
                else if (Session["UserName"] != null)
                {
                    lblProfileName.Text = Session["UserName"].ToString();
                }
            }
            catch (Exception ex)
            {
                if (Session["UserName"] != null)
                {
                    lblProfileName.Text = Session["UserName"].ToString();
                }
                ShowAlert("Failed to load profile: " + ex.Message, false);
            }
        }

        private void LoadUserOrders()
        {
            string email = Session["UserEmail"].ToString();

            try
            {
                string sql = "SELECT id, order_number, created_at, customer_name, total_amount, payment_method, order_status, ISNULL(return_status, 'None') as return_status FROM orders WHERE user_email=@email ORDER BY id DESC";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@email", email));

                if (dt != null && dt.Rows.Count > 0)
                {
                    int total = dt.Rows.Count;
                    int delivered = 0;
                    int processing = 0;
                    decimal totalSpent = 0;

                    if (!dt.Columns.Contains("product_names"))
                    {
                        dt.Columns.Add("product_names", typeof(string));
                    }

                    foreach (DataRow row in dt.Rows)
                    {
                        string status = row["order_status"].ToString();
                        if (IsOrderDelivered(status)) delivered++;
                        else if (status.Equals("Processing", StringComparison.OrdinalIgnoreCase)) processing++;

                        if (row["total_amount"] != DBNull.Value)
                        {
                            totalSpent += Convert.ToDecimal(row["total_amount"]);
                        }

                        // Query order items for this order
                        int orderId = Convert.ToInt32(row["id"]);
                        try
                        {
                            string itemSql = "SELECT product_name FROM order_items WHERE order_id=@oid";
                            DataTable dtItems = DbHelper.ExecuteDataTable(itemSql, new SqlParameter("@oid", orderId));
                            System.Collections.Generic.List<string> pnames = new System.Collections.Generic.List<string>();
                            if (dtItems != null && dtItems.Rows.Count > 0)
                            {
                                foreach (DataRow ir in dtItems.Rows)
                                {
                                    string pn = ir["product_name"].ToString();
                                    if (!pnames.Contains(pn)) pnames.Add(pn);
                                }
                            }
                            if (pnames.Count == 0) pnames.Add("Garment Item");
                            row["product_names"] = string.Join(" | ", pnames);
                        }
                        catch
                        {
                            row["product_names"] = "Garment Item";
                        }
                    }

                    lblTotalOrders.Text = total.ToString();
                    lblDeliveredOrders.Text = delivered.ToString();
                    lblProcessingOrders.Text = processing.ToString();
                    lblTotalSpent.Text = "&#8377;" + totalSpent.ToString("N0");

                    // Bind recent orders (top 3)
                    DataTable dtRecent = dt.Clone();
                    int count = Math.Min(3, dt.Rows.Count);
                    for (int i = 0; i < count; i++)
                    {
                        dtRecent.ImportRow(dt.Rows[i]);
                    }

                    rptRecentOrders.DataSource = dtRecent;
                    rptRecentOrders.DataBind();
                    pnlNoRecentOrders.Visible = false;

                    // Bind all orders
                    rptAllOrders.DataSource = dt;
                    rptAllOrders.DataBind();
                    pnlNoAllOrders.Visible = false;
                }
                else
                {
                    lblTotalOrders.Text = "0";
                    lblDeliveredOrders.Text = "0";
                    lblProcessingOrders.Text = "0";
                    lblTotalSpent.Text = "&#8377;0";

                    rptRecentOrders.DataSource = null;
                    rptRecentOrders.DataBind();
                    pnlNoRecentOrders.Visible = true;

                    rptAllOrders.DataSource = null;
                    rptAllOrders.DataBind();
                    pnlNoAllOrders.Visible = true;
                }
            }
            catch
            {
                lblTotalOrders.Text = "0";
                lblDeliveredOrders.Text = "0";
                lblProcessingOrders.Text = "0";
                lblTotalSpent.Text = "&#8377;0";
                pnlNoRecentOrders.Visible = true;
                pnlNoAllOrders.Visible = true;
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "profile";
            if (!Page.IsValid) return;

            string email = Session["UserEmail"].ToString();
            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string fullName = (firstName + " " + lastName).Trim();
            string phone = txtPhone.Text.Trim();

            try
            {
                string sql = "UPDATE users SET name=@name, phone=@phone WHERE email=@email";
                DbHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@name", fullName),
                    new SqlParameter("@phone", phone),
                    new SqlParameter("@email", email));

                Session["UserName"] = fullName;
                lblProfileName.Text = fullName;

                ShowAlert("Profile information saved successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error updating profile: " + ex.Message, false);
            }
        }

        protected void btnSaveAddress_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "address";
            if (!Page.IsValid) return;

            string email = Session["UserEmail"].ToString();
            string line = txtAddressLine.Text.Trim();
            string city = txtCity.Text.Trim();
            string state = txtState.Text.Trim();
            string pin = txtPincode.Text.Trim();
            string country = string.IsNullOrWhiteSpace(txtCountry.Text) ? "India" : txtCountry.Text.Trim();

            string fullAddress = line + ", " + city + ", " + state + " - " + pin + ", " + country;

            try
            {
                string sql = "UPDATE users SET address=@address WHERE email=@email";
                DbHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@address", fullAddress),
                    new SqlParameter("@email", email));

                lblDisplayAddress.Text = Server.HtmlEncode(fullAddress);
                ShowAlert("Delivery address saved successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving address: " + ex.Message, false);
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "password";
            if (!Page.IsValid) return;

            string email = Session["UserEmail"].ToString();
            string currentPass = txtCurrentPassword.Text.Trim();
            string newPass = txtNewPassword.Text.Trim();

            try
            {
                // Verify current password
                string checkSql = "SELECT COUNT(*) FROM users WHERE email=@email AND password=@pass";
                object countObj = DbHelper.ExecuteScalar(checkSql,
                    new SqlParameter("@email", email),
                    new SqlParameter("@pass", currentPass));

                if (Convert.ToInt32(countObj) == 0)
                {
                    ShowAlert("Current password is incorrect. Please try again.", false);
                    return;
                }

                // Update password
                string updateSql = "UPDATE users SET password=@newPass WHERE email=@email";
                DbHelper.ExecuteNonQuery(updateSql,
                    new SqlParameter("@newPass", newPass),
                    new SqlParameter("@email", email));

                txtCurrentPassword.Text = string.Empty;
                txtNewPassword.Text = string.Empty;
                txtConfirmNewPassword.Text = string.Empty;

                ShowAlert("Password changed successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error changing password: " + ex.Message, false);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("login.aspx");
        }

        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            hfActiveTab.Value = "orders";
            string customerName = Session["UserName"] != null ? Session["UserName"].ToString() : "Customer";
            string pName = (hfRateProductName != null && !string.IsNullOrWhiteSpace(hfRateProductName.Value))
                ? hfRateProductName.Value.Trim()
                : (Request.Form["rateProductSelect"] ?? "Garment Product");
            if (string.IsNullOrEmpty(pName) || pName == "Select Product")
            {
                pName = "Garment Product";
            }

            decimal rating = 5.0m;
            decimal.TryParse(hfRatingScore.Value, out rating);
            if (rating < 1.0m || rating > 5.0m) rating = 5.0m;

            string comment = txtRateComment.Text.Trim();
            if (string.IsNullOrEmpty(comment))
            {
                comment = "Great fabric quality and comfortable fit!";
            }

            try
            {
                object pidObj = DbHelper.ExecuteScalar("SELECT TOP 1 id FROM products WHERE name=@pname", new SqlParameter("@pname", pName));
                int prodId = (pidObj != null && pidObj != DBNull.Value) ? Convert.ToInt32(pidObj) : 0;

                string insertReviewSql = @"INSERT INTO reviews (product_id, product_name, customer_name, rating, comment, status, created_at)
                                           VALUES (@pid, @pname, @cname, @rating, @comment, 'Approved', GETDATE())";
                DbHelper.ExecuteNonQuery(insertReviewSql,
                    new SqlParameter("@pid", prodId > 0 ? (object)prodId : DBNull.Value),
                    new SqlParameter("@pname", pName),
                    new SqlParameter("@cname", customerName),
                    new SqlParameter("@rating", rating),
                    new SqlParameter("@comment", comment));

                // Sync average rating into products table
                DbHelper.ExecuteNonQuery(@"
                    UPDATE products 
                    SET rating = ISNULL((SELECT ROUND(AVG(CAST(r.rating AS DECIMAL(3,1))), 1) FROM reviews r WHERE r.product_name = @pname OR (r.product_id IS NOT NULL AND r.product_id = products.id)), rating)
                    WHERE name = @pname OR id = @pid",
                    new SqlParameter("@pname", pName),
                    new SqlParameter("@pid", prodId));

                txtRateComment.Text = "";
                hfRatingScore.Value = "5";

                ShowAlert("Thank you! Your " + rating.ToString("0.0") + "-star review for \"" + Server.HtmlEncode(pName) + "\" has been recorded and submitted to store administration.", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error submitting review: " + ex.Message, false);
            }
        }

        protected void btnSubmitReturnOrder_Click(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            string userEmail = Session["UserEmail"].ToString();
            string orderNum = hfReturnOrderNumber.Value.Trim();
            string orderIdStr = hfReturnOrderId.Value.Trim();
            string prods = hfReturnProductNames.Value.Trim();
            string amountStr = hfReturnTotalAmount.Value.Trim().Replace(",", "");
            string reason = ddlReturnReason.SelectedValue;
            string comments = txtReturnComments.Text.Trim();

            if (string.IsNullOrEmpty(orderNum))
            {
                ShowAlert("Invalid Order reference for return request.", false);
                return;
            }

            try
            {
                int orderId = 0;
                int.TryParse(orderIdStr, out orderId);

                decimal amount = 0m;
                decimal.TryParse(amountStr, out amount);

                string customerName = Session["UserName"] != null ? Session["UserName"].ToString() : "Customer";

                // Insert into order_returns table
                string insertSql = @"
                    INSERT INTO order_returns 
                    (order_id, order_number, user_email, customer_name, product_names, total_amount, reason, comments, return_status, refund_amount, requested_at)
                    VALUES 
                    (@oid, @ordNum, @email, @cname, @pnames, @amount, @reason, @comments, 'Pending', @amount, GETDATE())";

                DbHelper.ExecuteNonQuery(insertSql,
                    new SqlParameter("@oid", orderId),
                    new SqlParameter("@ordNum", orderNum),
                    new SqlParameter("@email", userEmail),
                    new SqlParameter("@cname", customerName),
                    new SqlParameter("@pnames", prods),
                    new SqlParameter("@amount", amount),
                    new SqlParameter("@reason", reason),
                    new SqlParameter("@comments", string.IsNullOrEmpty(comments) ? (object)DBNull.Value : comments));

                // Update orders table return_status
                DbHelper.ExecuteNonQuery("UPDATE orders SET return_status = 'Pending' WHERE order_number = @ordNum",
                    new SqlParameter("@ordNum", orderNum));

                txtReturnComments.Text = "";
                hfReturnOrderNumber.Value = "";

                // Reload orders to reflect updated status
                LoadUserOrders();

                ShowAlert("✓ Return request for Order #" + Server.HtmlEncode(orderNum) + " submitted successfully! Our administrative team will review your request.", true);
            }
            catch (Exception ex)
            {
                ShowAlert("Error submitting return request: " + ex.Message, false);
            }
        }

        private void ShowAlert(string message, bool isSuccess)
        {
            pnlAlert.Visible = true;
            lblAlertMessage.Text = message;
            pnlAlert.CssClass = isSuccess ? "alert-banner alert-success" : "alert-banner alert-danger";
        }
    }
}