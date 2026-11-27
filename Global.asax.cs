using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace textiles
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            DbHelper.EnsureDatabaseSchemaAndSeed();
        }

        void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();
            if (ex is HttpException httpEx)
            {
                if (httpEx.Message.IndexOf("Maximum request length", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    Server.ClearError();
                    Response.Redirect("~/admin.aspx");
                }
            }
        }
    }
}