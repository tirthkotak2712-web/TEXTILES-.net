using System;
using System.Data.SqlClient;
using System.Web.UI;

namespace textiles
{
    public partial class SiteMaster : MasterPage
    {
        public int CartCount = 0;
        public int WishlistCount = 0;
        public bool IsLoggedIn = false;
        public string UserName = "";
        public bool IsAdmin = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] != null)
            {
                IsLoggedIn = true;
                UserName = Session["UserName"] != null ? Session["UserName"].ToString() : Session["UserEmail"].ToString();
                if (Session["UserRole"] != null && Session["UserRole"].ToString().ToLower() == "admin")
                {
                    IsAdmin = true;
                }
            }

            // Calculate cart and wishlist item count
            if (Session["UserEmail"] != null)
            {
                string userEmail = Session["UserEmail"].ToString();
                try
                {
                    string sql = "SELECT ISNULL(SUM(quantity), 0) FROM cart WHERE user_email = @email";
                    object res = DbHelper.ExecuteScalar(sql, new SqlParameter("@email", userEmail));
                    if (res != null && res != DBNull.Value)
                    {
                        CartCount = Convert.ToInt32(res);
                    }
                }
                catch
                {
                    CartCount = 0;
                }

                try
                {
                    string sqlWish = "SELECT COUNT(*) FROM wishlist WHERE user_email = @email";
                    object resWish = DbHelper.ExecuteScalar(sqlWish, new SqlParameter("@email", userEmail));
                    if (resWish != null && resWish != DBNull.Value)
                    {
                        WishlistCount = Convert.ToInt32(resWish);
                    }
                }
                catch
                {
                    WishlistCount = 0;
                }
            }
            else
            {
                CartCount = 0;
                WishlistCount = 0;
            }
        }
    }
}