using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace textiles
{
    public partial class cart : Page
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
                string returnUrl = "cart.aspx";
                if (Request.QueryString.Count > 0)
                {
                    returnUrl += "?" + Request.QueryString.ToString();
                }
                Response.Redirect("login.aspx?returnUrl=" + Server.UrlEncode(returnUrl));
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["action"] == "add" && Request.QueryString["id"] != null)
                {
                    int pid;
                    if (int.TryParse(Request.QueryString["id"], out pid))
                    {
                        string size = Request.QueryString["size"];
                        if (string.IsNullOrEmpty(size)) size = "M";
                        AddToCart(pid, size);
                    }
                }

                LoadCart();
            }
        }

        private void AddToCart(int productId, string size = "M")
        {
            string userEmail = Session["UserEmail"].ToString();
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
                        return; // Out of stock or inactive: do not add
                    }

                    string uSize = size.ToUpper();
                    int sizeStock = 0;
                    switch (uSize)
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
                        return; // Out of stock for this size
                    }

                    string pName = row["name"].ToString();
                    decimal pPrice = Convert.ToDecimal(row["price"]);
                    string pImage = row["image_url"].ToString();

                    string checkSql = "SELECT TOP 1 id, quantity FROM cart WHERE user_email=@email AND product_id=@pid AND size=@size";
                    DataTable dtCart = DbHelper.ExecuteDataTable(checkSql, 
                        new SqlParameter("@email", userEmail),
                        new SqlParameter("@pid", productId),
                        new SqlParameter("@size", size));

                    if (dtCart != null && dtCart.Rows.Count > 0)
                    {
                        int cartId = Convert.ToInt32(dtCart.Rows[0]["id"]);
                        int qty = Convert.ToInt32(dtCart.Rows[0]["quantity"]) + 1;
                        if (qty > sizeStock) return; // Do not exceed available size stock!
                        DbHelper.ExecuteNonQuery("UPDATE cart SET quantity=@qty WHERE id=@cid", 
                            new SqlParameter("@qty", qty),
                            new SqlParameter("@cid", cartId));
                    }
                    else
                    {
                        DbHelper.ExecuteNonQuery("INSERT INTO cart (user_email, product_id, product_name, price, image_url, quantity, size) VALUES (@email, @pid, @pname, @price, @image, 1, @size)",
                            new SqlParameter("@email", userEmail),
                            new SqlParameter("@pid", productId),
                            new SqlParameter("@pname", pName),
                            new SqlParameter("@price", pPrice),
                            new SqlParameter("@image", pImage),
                            new SqlParameter("@size", size));
                    }
                }
            }
            catch
            {
            }
        }

        private void LoadCart()
        {
            string userEmail = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "guest@textiles.com";
            try
            {
                string sql = "SELECT * FROM cart WHERE user_email=@email ORDER BY id DESC";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@email", userEmail));

                if ((dt == null || dt.Rows.Count == 0) && userEmail != "guest@textiles.com")
                {
                    DataTable dtGuest = DbHelper.ExecuteDataTable("SELECT * FROM cart WHERE user_email='guest@textiles.com' ORDER BY id DESC");
                    if (dtGuest != null && dtGuest.Rows.Count > 0)
                    {
                        dt = dtGuest;
                        DbHelper.ExecuteNonQuery("UPDATE cart SET user_email=@email WHERE user_email='guest@textiles.com'", new SqlParameter("@email", userEmail));
                    }
                }

                if (dt != null && dt.Rows.Count > 0)
                {
                    decimal subtotal = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        decimal price = Convert.ToDecimal(row["price"]);
                        int qty = Convert.ToInt32(row["quantity"]);
                        subtotal += price * qty;
                    }

                    lblSubtotal.Text = subtotal.ToString("N0");
                    if (lblShipping != null) lblShipping.Text = "FREE";
                    decimal tax = Math.Round(subtotal * 0.05m);
                    if (lblTax != null) lblTax.Text = tax.ToString("N0");
                    lblTotal.Text = subtotal.ToString("N0");

                    rptCart.DataSource = dt;
                    rptCart.DataBind();
                    pnlCart.Visible = true;
                    pnlEmpty.Visible = false;
                }
                else
                {
                    pnlCart.Visible = false;
                    pnlEmpty.Visible = true;
                }
            }
            catch
            {
                pnlCart.Visible = false;
                pnlEmpty.Visible = true;
            }
        }

        protected void rptCart_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int cartId = Convert.ToInt32(e.CommandArgument);
            try
            {
                if (e.CommandName == "Remove")
                {
                    DbHelper.ExecuteNonQuery("DELETE FROM cart WHERE id=@id", new SqlParameter("@id", cartId));
                }
                else if (e.CommandName == "Increase")
                {
                    DataTable dtItem = DbHelper.ExecuteDataTable(@"
                        SELECT c.quantity, c.size, ISNULL(p.stock, 0) as stock,
                               ISNULL(p.stock_s, 0) as stock_s,
                               ISNULL(p.stock_m, 0) as stock_m,
                               ISNULL(p.stock_l, 0) as stock_l,
                               ISNULL(p.stock_xl, 0) as stock_xl,
                               ISNULL(p.stock_xxl, 0) as stock_xxl
                        FROM cart c 
                        LEFT JOIN products p ON c.product_id = p.id 
                        WHERE c.id = @id", new SqlParameter("@id", cartId));
                    if (dtItem != null && dtItem.Rows.Count > 0)
                    {
                        int curQty = Convert.ToInt32(dtItem.Rows[0]["quantity"]);
                        string itmSize = dtItem.Rows[0]["size"] != DBNull.Value ? dtItem.Rows[0]["size"].ToString().ToUpper() : "M";
                        int sizeStock = 0;
                        switch (itmSize)
                        {
                            case "S": sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock_s"]); break;
                            case "M": sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock_m"]); break;
                            case "L": sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock_l"]); break;
                            case "XL": sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock_xl"]); break;
                            case "XXL": sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock_xxl"]); break;
                            default: sizeStock = Convert.ToInt32(dtItem.Rows[0]["stock"]); break;
                        }

                        if (curQty < sizeStock)
                        {
                            DbHelper.ExecuteNonQuery("UPDATE cart SET quantity = quantity + 1 WHERE id=@id", new SqlParameter("@id", cartId));
                        }
                    }
                }
                else if (e.CommandName == "Decrease")
                {
                    DataTable dt = DbHelper.ExecuteDataTable("SELECT quantity FROM cart WHERE id=@id", new SqlParameter("@id", cartId));
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        int currentQty = Convert.ToInt32(dt.Rows[0]["quantity"]);
                        if (currentQty > 1)
                        {
                            DbHelper.ExecuteNonQuery("UPDATE cart SET quantity = quantity - 1 WHERE id=@id", new SqlParameter("@id", cartId));
                        }
                        else
                        {
                            DbHelper.ExecuteNonQuery("DELETE FROM cart WHERE id=@id", new SqlParameter("@id", cartId));
                        }
                    }
                }
            }
            catch
            {
            }

            LoadCart();
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            string userEmail = Session["UserEmail"] != null ? Session["UserEmail"].ToString() : "guest@textiles.com";
            try
            {
                DbHelper.ExecuteNonQuery("DELETE FROM cart WHERE user_email=@email", new SqlParameter("@email", userEmail));
            }
            catch
            {
            }

            LoadCart();
        }
    }
}