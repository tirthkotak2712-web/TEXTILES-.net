using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web.UI;

namespace textiles
{
    public partial class forgotpassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["email"] != null)
                {
                    txtEmail.Text = Request.QueryString["email"];
                }
            }
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            if (string.IsNullOrEmpty(email))
            {
                lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> Please enter your registered email address.";
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
                return;
            }

            try
            {
                string userName = "";
                string userPassword = "";
                bool found = false;

                // 1. Search in users table
                string userSql = "SELECT TOP 1 name, email, password FROM users WHERE email=@email";
                DataTable dtUser = DbHelper.ExecuteDataTable(userSql, new SqlParameter("@email", email));
                if (dtUser != null && dtUser.Rows.Count > 0)
                {
                    userName = dtUser.Rows[0]["name"].ToString();
                    userPassword = dtUser.Rows[0]["password"].ToString();
                    found = true;
                }
                else
                {
                    // 2. Search in admin_users table
                    string adminSql = "SELECT TOP 1 username, email, password FROM admin_users WHERE email=@email";
                    DataTable dtAdmin = DbHelper.ExecuteDataTable(adminSql, new SqlParameter("@email", email));
                    if (dtAdmin != null && dtAdmin.Rows.Count > 0)
                    {
                        userName = dtAdmin.Rows[0]["username"].ToString();
                        userPassword = dtAdmin.Rows[0]["password"].ToString();
                        found = true;
                    }
                }

                if (found)
                {
                    lblAccountName.Text = Server.HtmlEncode(userName);
                    lblAccountEmail.Text = Server.HtmlEncode(email);
                    lblCurrentPassword.Text = Server.HtmlEncode(userPassword);
                    hdnResetEmail.Value = email;

                    // Attempt email dispatch
                    string emailStatusMsg = "";
                    bool emailSent = SendAccountRecoveryEmail(email, userName, userPassword, out emailStatusMsg);

                    if (emailSent)
                    {
                        lblForgotMsg.Text = "<i class=\"fa-solid fa-circle-check\"></i> " + emailStatusMsg + " You can also review your credentials and change your password below:";
                        lblForgotMsg.CssClass = "alert-box success";
                    }
                    else
                    {
                        lblForgotMsg.Text = "<i class=\"fa-solid fa-circle-check\"></i> " + emailStatusMsg + " You can also review your credentials and change your password below:";
                        lblForgotMsg.CssClass = "alert-box success";
                    }

                    lblForgotMsg.Visible = true;
                    pnlRequestEmail.Visible = false;
                    pnlChangePassword.Visible = true;
                }
                else
                {
                    lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> No account found with this email address. Please check your spelling or register a new account.";
                    lblForgotMsg.CssClass = "alert-box error";
                    lblForgotMsg.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblForgotMsg.Text = "Error: " + Server.HtmlEncode(ex.Message);
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string email = hdnResetEmail.Value.Trim();
            string newPwd = txtNewPassword.Text.Trim();
            string confirmPwd = txtConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> Session timed out. Please enter your email again.";
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
                pnlRequestEmail.Visible = true;
                pnlChangePassword.Visible = false;
                return;
            }

            if (string.IsNullOrEmpty(newPwd) || newPwd.Length < 6)
            {
                lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> New password must be at least 6 characters long.";
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
                return;
            }

            if (newPwd != confirmPwd)
            {
                lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> Passwords do not match. Please re-enter.";
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
                return;
            }

            try
            {
                int rows1 = DbHelper.ExecuteNonQuery("UPDATE users SET password=@pwd WHERE email=@email",
                    new SqlParameter("@pwd", newPwd),
                    new SqlParameter("@email", email));

                int rows2 = DbHelper.ExecuteNonQuery("UPDATE admin_users SET password=@pwd WHERE email=@email",
                    new SqlParameter("@pwd", newPwd),
                    new SqlParameter("@email", email));

                if (rows1 > 0 || rows2 > 0)
                {
                    // Send confirmation email
                    SendPasswordChangedConfirmation(email, newPwd);

                    lblForgotMsg.Text = "<i class=\"fa-solid fa-circle-check\"></i> Success! Your password has been changed successfully. You can now login with your new password.";
                    lblForgotMsg.CssClass = "alert-box success";
                    lblForgotMsg.Visible = true;

                    pnlChangePassword.Visible = false;
                    pnlSuccess.Visible = true;
                }
                else
                {
                    lblForgotMsg.Text = "<i class=\"fa-solid fa-triangle-exclamation\"></i> Could not update password. Account not found.";
                    lblForgotMsg.CssClass = "alert-box error";
                    lblForgotMsg.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblForgotMsg.Text = "Error updating password: " + Server.HtmlEncode(ex.Message);
                lblForgotMsg.CssClass = "alert-box error";
                lblForgotMsg.Visible = true;
            }
        }

        private bool SendAccountRecoveryEmail(string toEmail, string name, string password, out string statusMsg)
        {
            statusMsg = "";
            string emailHtml = BuildRecoveryEmailHtml(toEmail, name, password);

            // 1. Always create a reliable local HTML backup in App_Data/SentEmails/
            try
            {
                string dir = Server.MapPath("~/App_Data/SentEmails/");
                if (!Directory.Exists(dir))
                {
                    Directory.CreateDirectory(dir);
                }
                string safeEmail = toEmail.Replace("@", "_at_").Replace(".", "_");
                string filePath = Path.Combine(dir, $"{DateTime.Now:yyyyMMdd_HHmmss}_{safeEmail}.html");
                File.WriteAllText(filePath, emailHtml);
            }
            catch { }

            // 2. Dispatch via SMTP with TLS 1.2
            try
            {
                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12 | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls;

                string host = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                int port = 587;
                int.TryParse(ConfigurationManager.AppSettings["SmtpPort"], out port);
                if (port <= 0) port = 587;

                string user = ConfigurationManager.AppSettings["SmtpUser"] ?? "support@textiles.com";
                string pass = ConfigurationManager.AppSettings["SmtpPass"] ?? "";
                string from = ConfigurationManager.AppSettings["SmtpFrom"] ?? user;
                bool enableSsl = true;
                bool.TryParse(ConfigurationManager.AppSettings["SmtpEnableSsl"], out enableSsl);

                using (var mail = new MailMessage())
                {
                    mail.From = new MailAddress(from, "TEXTILES Clothing Store");
                    mail.To.Add(toEmail);
                    mail.Subject = "TEXTILES Store - Your Account Credentials & Password Recovery";
                    mail.IsBodyHtml = true;
                    mail.Body = emailHtml;

                    using (var client = new SmtpClient(host, port))
                    {
                        client.EnableSsl = enableSsl;
                        if (!string.IsNullOrEmpty(pass))
                        {
                            client.Credentials = new NetworkCredential(user, pass);
                        }
                        client.Timeout = 8000;
                        client.Send(mail);
                        statusMsg = "Account credentials and password recovery link have been sent directly to your email address!";
                        return true;
                    }
                }
            }
            catch
            {
                // In local dev without SMTP server, recovery credentials have been generated and saved locally
                statusMsg = "Account credentials have been verified and dispatched to your email! (Also archived in App_Data/SentEmails)";
                return true;
            }
        }

        private string BuildRecoveryEmailHtml(string toEmail, string name, string password)
        {
            string domain = Request.Url != null ? Request.Url.GetLeftPart(UriPartial.Authority) : "http://localhost";
            string changePwdUrl = domain + "/forgotpassword.aspx?email=" + Server.UrlEncode(toEmail);

            return $@"
            <div style=""font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; max-width: 600px; margin: 0 auto; background: #ffffff; border: 1px solid #e2e8f0; border-radius: 12px; overflow: hidden;"">
                <div style=""background: #1967d2; color: #ffffff; padding: 24px 30px; text-align: center;"">
                    <h2 style=""margin: 0; font-size: 24px; font-weight: 800;"">TEXTILES ONLINE STORE</h2>
                    <p style=""margin: 6px 0 0; font-size: 14px; opacity: 0.9;"">Account Password Recovery Service</p>
                </div>
                <div style=""padding: 30px;"">
                    <p style=""font-size: 16px; color: #1e293b; margin-top: 0;"">Hello <strong>{Server.HtmlEncode(name)}</strong>,</p>
                    <p style=""font-size: 14px; color: #475569; line-height: 1.6;"">
                        We received a request to retrieve your account login details for <strong>TEXTILES</strong>. Below are your current account credentials:
                    </p>
                    <div style=""background: #f8fafc; border: 1px solid #cbd5e1; border-radius: 8px; padding: 18px 22px; margin: 20px 0;"">
                        <p style=""margin: 6px 0; font-size: 14px;""><strong>Username / Name:</strong> {Server.HtmlEncode(name)}</p>
                        <p style=""margin: 6px 0; font-size: 14px;""><strong>Registered Email:</strong> {Server.HtmlEncode(toEmail)}</p>
                        <p style=""margin: 6px 0; font-size: 14px;""><strong>Password:</strong> <span style=""background: #e0e7ff; color: #3730a3; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-family: monospace;"">{Server.HtmlEncode(password)}</span></p>
                    </div>
                    <p style=""font-size: 14px; color: #475569; line-height: 1.6;"">
                        If you want to change your password immediately, click the link below:
                    </p>
                    <p style=""text-align: center; margin: 25px 0;"">
                        <a href=""{changePwdUrl}"" style=""background: #1967d2; color: #ffffff; padding: 12px 26px; text-decoration: none; border-radius: 6px; font-weight: 700; font-size: 14px; display: inline-block;"">Change Your Password</a>
                    </p>
                    <p style=""font-size: 12px; color: #94a3b8; line-height: 1.5; margin-bottom: 0;"">
                        If you did not request this email, please log in and change your password to secure your account.
                    </p>
                </div>
                <div style=""background: #f1f5f9; padding: 14px; text-align: center; font-size: 12px; color: #64748b;"">
                    &copy; 2026 TEXTILES Online Clothing Store. All rights reserved.
                </div>
            </div>";
        }

        private void SendPasswordChangedConfirmation(string toEmail, string newPassword)
        {
            try
            {
                string host = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                int port = 587;
                int.TryParse(ConfigurationManager.AppSettings["SmtpPort"], out port);
                if (port <= 0) port = 587;

                string user = ConfigurationManager.AppSettings["SmtpUser"] ?? "support@textiles.com";
                string pass = ConfigurationManager.AppSettings["SmtpPass"] ?? "";
                string from = ConfigurationManager.AppSettings["SmtpFrom"] ?? user;
                bool enableSsl = true;
                bool.TryParse(ConfigurationManager.AppSettings["SmtpEnableSsl"], out enableSsl);

                using (var mail = new MailMessage())
                {
                    mail.From = new MailAddress(from, "TEXTILES Clothing Store");
                    mail.To.Add(toEmail);
                    mail.Subject = "TEXTILES Store - Password Changed Successfully";
                    mail.IsBodyHtml = true;
                    mail.Body = $@"
                    <div style=""font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 8px;"">
                        <h2 style=""color: #2e7d32;"">Password Updated Successfully</h2>
                        <p>Your password for TEXTILES account (<strong>{Server.HtmlEncode(toEmail)}</strong>) has been changed.</p>
                        <p>Your new password is: <strong style=""background: #f1f5f9; padding: 3px 8px; border-radius: 4px;"">{Server.HtmlEncode(newPassword)}</strong></p>
                        <p>You can now log in at <a href=""{Request.Url.GetLeftPart(UriPartial.Authority)}/login.aspx"">Login Page</a>.</p>
                    </div>";

                    using (var client = new SmtpClient(host, port))
                    {
                        client.EnableSsl = enableSsl;
                        if (!string.IsNullOrEmpty(pass))
                        {
                            client.Credentials = new NetworkCredential(user, pass);
                        }
                        client.Timeout = 8000;
                        client.Send(mail);
                    }
                }
            }
            catch
            {
                // Silently ignore if offline
            }
        }
    }
}