<%@ Page Title="Forgot Password"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="forgotpassword.aspx.cs"
    Inherits="textiles.forgotpassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    .forgot-page {
        min-height: 650px;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 50px 20px;
        background: #f4f6f9;
    }

    .forgot-container {
        width: 100%;
        max-width: 480px;
        background: #ffffff;
        border-radius: 14px;
        padding: 40px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        border: 1px solid #e2e8f0;
    }

    .forgot-header {
        text-align: center;
        margin-bottom: 25px;
    }

    .forgot-icon {
        width: 68px;
        height: 68px;
        margin: 0 auto 15px;
        border-radius: 50%;
        background: #1967d2;
        color: #ffffff;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 28px;
        box-shadow: 0 4px 12px rgba(25, 103, 210, 0.25);
    }

    .forgot-header h1 {
        font-size: 26px;
        font-weight: 800;
        color: #1e293b;
        margin-bottom: 8px;
    }

    .forgot-header p {
        color: #64748b;
        font-size: 14px;
        line-height: 1.5;
    }

    .form-group {
        margin-bottom: 20px;
    }

    .form-group label {
        display: block;
        font-weight: 700;
        color: #334155;
        margin-bottom: 7px;
        font-size: 13.5px;
    }

    .form-control {
        width: 100%;
        padding: 12px 14px;
        border: 1.5px solid #cbd5e1;
        border-radius: 8px;
        font-size: 14.5px;
        outline: none;
        box-sizing: border-box;
        transition: border 0.2s;
    }

    .form-control:focus {
        border-color: #1967d2;
        box-shadow: 0 0 0 3px rgba(25, 103, 210, 0.15);
    }

    .reset-btn {
        width: 100%;
        background: #1967d2;
        color: white;
        border: none;
        padding: 13px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .reset-btn:hover {
        background: #1557b0;
    }

    .btn-update-pwd {
        width: 100%;
        background: #2e7d32;
        color: white;
        border: none;
        padding: 13px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.2s;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
    }

    .btn-update-pwd:hover {
        background: #1b5e20;
    }

    /* Account Details Box */
    .account-details-box {
        background: #f8fafc;
        border: 1.5px solid #bfdbfe;
        border-radius: 10px;
        padding: 16px 20px;
        margin-bottom: 25px;
    }

    .account-details-box h3 {
        font-size: 15px;
        font-weight: 800;
        color: #1e40af;
        margin-bottom: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .account-row {
        display: flex;
        justify-content: space-between;
        padding: 6px 0;
        font-size: 13.5px;
        border-bottom: 1px dashed #e2e8f0;
    }

    .account-row:last-child {
        border-bottom: none;
    }

    .account-label {
        color: #64748b;
        font-weight: 600;
    }

    .account-val {
        color: #0f172a;
        font-weight: 700;
    }

    .pwd-pill {
        background: #e0e7ff;
        color: #3730a3;
        padding: 2px 8px;
        border-radius: 6px;
        font-family: monospace;
        font-size: 13px;
    }

    .alert-box {
        padding: 12px 16px;
        border-radius: 8px;
        font-size: 13.5px;
        font-weight: 600;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        line-height: 1.4;
    }

    .alert-box.success {
        background: #dcfce7;
        color: #15803d;
        border: 1px solid #bbf7d0;
    }

    .alert-box.error {
        background: #fee2e2;
        color: #b91c1c;
        border: 1px solid #fecaca;
    }

    .alert-box.info {
        background: #e0f2fe;
        color: #0369a1;
        border: 1px solid #bae6fd;
    }

    .back-login {
        text-align: center;
        margin-top: 25px;
        font-size: 14px;
    }

    .back-login a {
        color: #1967d2;
        text-decoration: none;
        font-weight: 700;
    }

    .back-login a:hover {
        text-decoration: underline;
    }

    .val-error {
        color: #dc2626;
        font-size: 12.5px;
        margin-top: 4px;
        display: block;
        font-weight: 600;
    }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<section class="forgot-page">
    <div class="forgot-container">
        <div class="forgot-header">
            <div class="forgot-icon">
                <i class="fa-solid fa-key"></i>
            </div>
            <h1>Password Recovery</h1>
            <p>Enter your registered email address to receive your account credentials and reset your password.</p>
        </div>

        <asp:Label ID="lblForgotMsg" runat="server" Visible="false" CssClass="alert-box info"></asp:Label>

        <!-- STEP 1: REQUEST EMAIL -->
        <asp:Panel ID="pnlRequestEmail" runat="server">
            <div class="form-group">
                <label>Registered Email Address <span style="color: #ef4444;">*</span></label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="e.g. user@example.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ErrorMessage="Email address is required." 
                    ValidationGroup="ForgotGroup" 
                    CssClass="val-error" 
                    Display="Dynamic" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                    ControlToValidate="txtEmail" 
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                    ErrorMessage="Please enter a valid email format." 
                    ValidationGroup="ForgotGroup" 
                    CssClass="val-error" 
                    Display="Dynamic" />
            </div>

            <asp:Button ID="btnReset" runat="server" 
                Text="Send Email & Retrieve Password" 
                CssClass="reset-btn" 
                ValidationGroup="ForgotGroup" 
                OnClick="btnReset_Click" />
        </asp:Panel>

        <!-- STEP 2: CREDENTIALS RETRIEVED & CHANGE PASSWORD FORM -->
        <asp:Panel ID="pnlChangePassword" runat="server" Visible="false">
            <div class="account-details-box">
                <h3><i class="fa-solid fa-shield-halved"></i> Account Recovered</h3>
                <div class="account-row">
                    <span class="account-label">User / Name:</span>
                    <asp:Label ID="lblAccountName" runat="server" CssClass="account-val"></asp:Label>
                </div>
                <div class="account-row">
                    <span class="account-label">Registered Email:</span>
                    <asp:Label ID="lblAccountEmail" runat="server" CssClass="account-val"></asp:Label>
                </div>
                <div class="account-row">
                    <span class="account-label">Current Password:</span>
                    <asp:Label ID="lblCurrentPassword" runat="server" CssClass="account-val pwd-pill"></asp:Label>
                </div>
            </div>

            <h3 style="font-size: 17px; font-weight: 800; color: #1e293b; margin-bottom: 14px;">
                <i class="fa-solid fa-lock" style="color: #1967d2;"></i> Change Password
            </h3>

            <asp:HiddenField ID="hdnResetEmail" runat="server" />

            <div class="form-group">
                <label>New Password <span style="color: #ef4444;">*</span></label>
                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Minimum 6 characters"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvNewPwd" runat="server" 
                    ControlToValidate="txtNewPassword" 
                    ErrorMessage="New password is required." 
                    ValidationGroup="ChangePwdGroup" 
                    CssClass="val-error" 
                    Display="Dynamic" />
            </div>

            <div class="form-group">
                <label>Confirm New Password <span style="color: #ef4444;">*</span></label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter new password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirmPwd" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ErrorMessage="Please confirm your new password." 
                    ValidationGroup="ChangePwdGroup" 
                    CssClass="val-error" 
                    Display="Dynamic" />
                <asp:CompareValidator ID="cmpPwd" runat="server" 
                    ControlToValidate="txtConfirmPassword" 
                    ControlToCompare="txtNewPassword" 
                    ErrorMessage="Passwords do not match." 
                    ValidationGroup="ChangePwdGroup" 
                    CssClass="val-error" 
                    Display="Dynamic" />
            </div>

            <asp:Button ID="btnUpdatePassword" runat="server" 
                Text="Save & Update Password" 
                CssClass="btn-update-pwd" 
                ValidationGroup="ChangePwdGroup" 
                OnClick="btnUpdatePassword_Click" />
        </asp:Panel>

        <!-- STEP 3: SUCCESS CONFIRMATION -->
        <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
            <div style="text-align: center; padding: 20px 0;">
                <a href="login.aspx" class="reset-btn" style="background: #2e7d32;">
                    <i class="fa-solid fa-arrow-right-to-bracket"></i> Proceed to Login
                </a>
            </div>
        </asp:Panel>

        <div class="back-login">
            <a href="login.aspx">
                <i class="fa-solid fa-arrow-left"></i> Back to Login
            </a>
        </div>
    </div>
</section>
</asp:Content>