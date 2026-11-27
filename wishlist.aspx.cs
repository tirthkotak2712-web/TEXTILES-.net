using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace textiles
{
    public partial class wishlist : Page
    {
        public int TotalWishlistItems = 0;

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
                string returnUrl = "wishlist.aspx";
                if (Request.QueryString.Count > 0)
                {
                    returnUrl += "?" + Request.QueryString.ToString();
                }
                Response.Redirect("login.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
                return;
            }

            if (!IsPostBack)
            {
                string action = Request.QueryString["action"];
                string idStr = Request.QueryString["id"];
                int productId;

                if (!string.IsNullOrEmpty(action) && int.TryParse(idStr, out productId))
                {
                    if (action.Equals("add", StringComparison.OrdinalIgnoreCase))
                    {
                        AddToWishlist(productId);
                    }
                    else if (action.Equals("remove", StringComparison.OrdinalIgnoreCase))
                    {
                        RemoveFromWishlist(productId);
                    }
                }

                LoadWishlist();
            }
        }

        private void AddToWishlist(int productId)
        {
            string userEmail = Session["UserEmail"].ToString();
            try
            {
                // Check if already in wishlist
                string checkSql = "SELECT COUNT(*) FROM wishlist WHERE user_email=@email AND product_id=@pid";
                int exists = Convert.ToInt32(DbHelper.ExecuteScalar(checkSql, 
                    new SqlParameter("@email", userEmail), 
                    new SqlParameter("@pid", productId)));

                if (exists == 0)
                {
                    // Fetch product details
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

                        lblWishlistMsg.Text = "<i class=\"fa-solid fa-circle-check\"></i> " + Server.HtmlEncode(pName) + " added to your wishlist!";
                        lblWishlistMsg.CssClass = "alert-banner alert-success";
                        lblWishlistMsg.Visible = true;
                    }
                }
                else
                {
                    lblWishlistMsg.Text = "<i class=\"fa-solid fa-circle-info\"></i> This product is already in your wishlist.";
                    lblWishlistMsg.CssClass = "alert-banner alert-info";
                    lblWishlistMsg.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblWishlistMsg.Text = "Error updating wishlist: " + Server.HtmlEncode(ex.Message);
                lblWishlistMsg.CssClass = "alert-banner alert-info";
                lblWishlistMsg.Visible = true;
            }
        }

        private void RemoveFromWishlist(int productId)
        {
            string userEmail = Session["UserEmail"].ToString();
            try
            {
                string sql = "DELETE FROM wishlist WHERE user_email=@email AND product_id=@pid";
                DbHelper.ExecuteNonQuery(sql,
                    new SqlParameter("@email", userEmail),
                    new SqlParameter("@pid", productId));

                lblWishlistMsg.Text = "<i class=\"fa-solid fa-circle-check\"></i> Item removed from your wishlist.";
                lblWishlistMsg.CssClass = "alert-banner alert-info";
                lblWishlistMsg.Visible = true;
            }
            catch (Exception ex)
            {
                lblWishlistMsg.Text = "Error removing item: " + Server.HtmlEncode(ex.Message);
                lblWishlistMsg.CssClass = "alert-banner alert-info";
                lblWishlistMsg.Visible = true;
            }
        }

        private void LoadWishlist()
        {
            string userEmail = Session["UserEmail"].ToString();
            try
            {
                string sql = @"
                    SELECT w.id, w.product_id, w.product_name, w.price, w.image_url,
                           ISNULL(p.stock, 0) as stock,
                           ISNULL(p.stock_s, 0) as stock_s,
                           ISNULL(p.stock_m, 0) as stock_m,
                           ISNULL(p.stock_l, 0) as stock_l,
                           ISNULL(p.stock_xl, 0) as stock_xl,
                           ISNULL(p.stock_xxl, 0) as stock_xxl,
                           ISNULL(p.available_sizes, 'S, M, L, XL, XXL') as available_sizes
                    FROM wishlist w
                    LEFT JOIN products p ON w.product_id = p.id
                    WHERE w.user_email = @email
                    ORDER BY w.id DESC";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@email", userEmail));

                TotalWishlistItems = dt != null ? dt.Rows.Count : 0;
                rptWishlist.DataSource = dt;
                rptWishlist.DataBind();
            }
            catch
            {
                TotalWishlistItems = 0;
            }
        }
    }
}
