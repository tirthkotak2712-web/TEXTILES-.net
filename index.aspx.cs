using System;
using System.Data;
using System.Web.UI;

namespace textiles
{
    public partial class index : Page
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
            if (!IsPostBack)
            {
                LoadFeaturedProducts();
            }
        }

        private void LoadFeaturedProducts()
        {
            DataTable dt = null;
            try
            {
                string sql = @"
                    SELECT p.id, p.name, p.category, p.price, p.original_price,
                           ISNULL((SELECT ROUND(AVG(CAST(r.rating AS DECIMAL(3,1))), 1) FROM reviews r WHERE r.product_name = p.name OR r.product_id = p.id), ISNULL(p.rating, 4.8)) as rating,
                           p.image_url, p.stock 
                    FROM products p 
                    WHERE ISNULL(p.is_active, 1) = 1 AND p.stock > 0 
                    ORDER BY p.id ASC";
                dt = DbHelper.ExecuteDataTable(sql);
            }
            catch
            {
                // Fallback to static products matching Figma wireframe
            }

            if (dt == null || dt.Rows.Count == 0)
            {
                dt = GetStaticFeaturedProducts();
            }

            rptFeaturedProducts.DataSource = dt;
            rptFeaturedProducts.DataBind();
        }

        private DataTable GetStaticFeaturedProducts()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("id", typeof(int));
            dt.Columns.Add("name", typeof(string));
            dt.Columns.Add("category", typeof(string));
            dt.Columns.Add("price", typeof(decimal));
            dt.Columns.Add("original_price", typeof(decimal));
            dt.Columns.Add("rating", typeof(double));
            dt.Columns.Add("image_url", typeof(string));
            dt.Columns.Add("stock", typeof(int));

            dt.Rows.Add(1, "Marble Swirl Print T-Shirt", "T-Shirts", 799.00m, 1199.00m, 4.8, "images/product_marble_tshirt.jpg", 40);
            dt.Rows.Add(2, "Gorilla Graphic T-Shirt", "T-Shirts", 849.00m, 1299.00m, 4.7, "images/product_gorilla_tshirt.jpg", 35);
            dt.Rows.Add(3, "Textiles Signature Hoodie", "Hoodies", 1599.00m, 2299.00m, 4.9, "images/product_textiles_hoodie.jpg", 25);
            dt.Rows.Add(4, "Tiger Varsity Jacket", "Jackets", 2499.00m, 3499.00m, 4.8, "images/product_tiger_jacket.jpg", 15);
            dt.Rows.Add(5, "Slim Fit Blue Jeans", "Jeans", 1299.00m, 1899.00m, 4.6, "images/product_slim_jeans.jpg", 30);

            return dt;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
            {
                Response.Redirect("product.aspx?q=" + Server.UrlEncode(txtSearch.Text.Trim()));
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = string.Empty;
            LoadFeaturedProducts();
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblNewsletterMsg.Text = "Thank you for subscribing to TEXTILES updates!";
            lblNewsletterMsg.Visible = true;
            txtNewsletterEmail.Text = string.Empty;
        }
    }
}