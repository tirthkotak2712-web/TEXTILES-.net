<%@ Page Title="My Account" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="textiles.profile" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

    <style>
        /* ================= PROFILE PAGE ================= */
        .profile-page {
            background: #f5f6f8;
            min-height: 700px;
            padding: 40px 0 60px;
        }

        .profile-container {
            width: 92%;
            max-width: 1350px;
            margin: auto;
        }

        /* ================= PAGE HEADER ================= */
        .profile-header {
            margin-bottom: 25px;
        }

        .profile-header h1 {
            font-size: 30px;
            color: #17323f;
            margin-bottom: 6px;
            font-weight: 700;
        }

        .profile-header p {
            color: #667085;
            margin: 0;
            font-size: 15px;
        }

        /* ================= ALERTS ================= */
        .alert-banner {
            padding: 14px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .alert-success {
            background: #d1e7dd;
            color: #0f5132;
            border: 1px solid #badbcc;
        }

        .alert-danger {
            background: #f8d7da;
            color: #842029;
            border: 1px solid #f5c2c7;
        }

        /* ================= PROFILE GRID ================= */
        .profile-layout {
            display: grid;
            grid-template-columns: 290px 1fr;
            gap: 28px;
            align-items: start;
        }

        /* ================= SIDEBAR ================= */
        .profile-sidebar {
            background: #ffffff;
            border-radius: 14px;
            padding: 30px 22px;
            text-align: center;
            box-shadow: 0 4px 18px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
        }

        .profile-image-box {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 16px;
        }

        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #28609d;
            background: #f1f5f9;
        }

        .upload-btn {
            position: absolute;
            bottom: 2px;
            right: 2px;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #28609d;
            color: #ffffff;
            border: 3px solid #ffffff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            transition: 0.2s;
        }

        .upload-btn:hover {
            background: #1d4b7c;
            transform: scale(1.05);
        }

        .profile-name {
            font-size: 20px;
            font-weight: 700;
            color: #17323f;
            margin-bottom: 5px;
        }

        .profile-email {
            color: #64748b;
            font-size: 13.5px;
            word-break: break-all;
            margin-bottom: 22px;
        }

        /* ================= MENU TABS ================= */
        .profile-menu {
            text-align: left;
            border-top: 1px solid #edf2f7;
            padding-top: 15px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .profile-menu button,
        .profile-menu .menu-link {
            width: 100%;
            border: none;
            background: transparent;
            padding: 12px 14px;
            text-align: left;
            cursor: pointer;
            border-radius: 8px;
            color: #475569;
            font-size: 14.5px;
            font-weight: 500;
            transition: all 0.25s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            box-sizing: border-box;
        }

        .profile-menu button i,
        .profile-menu .menu-link i {
            width: 20px;
            text-align: center;
            color: #64748b;
            font-size: 16px;
        }

        .profile-menu button:hover,
        .profile-menu button.active {
            background: #eef4fa;
            color: #28609d;
            font-weight: 600;
        }

        .profile-menu button:hover i,
        .profile-menu button.active i {
            color: #28609d;
        }

        .logout-link {
            color: #dc3545 !important;
            margin-top: 10px;
            border-top: 1px solid #edf2f7 !important;
            padding-top: 14px !important;
            border-radius: 0 !important;
        }

        .logout-link i {
            color: #dc3545 !important;
        }

        .logout-link:hover {
            background: #fff5f5 !important;
        }

        /* ================= CONTENT CONTAINER ================= */
        .profile-content {
            min-width: 0;
        }

        .profile-section {
            display: none;
            background: #ffffff;
            border-radius: 14px;
            padding: 32px 30px;
            box-shadow: 0 4px 18px rgba(0,0,0,0.06);
            border: 1px solid #e9ecef;
            animation: fadeIn 0.3s ease;
        }

        .profile-section.active-section {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .section-title {
            font-size: 22px;
            font-weight: 700;
            color: #17323f;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #28609d;
        }

        .section-description {
            color: #64748b;
            margin-bottom: 25px;
            font-size: 14px;
        }

        /* ================= STATS GRID ================= */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 30px;
        }

        .stat-card {
            padding: 20px 18px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            text-align: left;
            transition: 0.2s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            border-color: #cbd5e1;
        }

        .stat-icon {
            font-size: 22px;
            color: #28609d;
            margin-bottom: 8px;
        }

        .stat-number {
            font-size: 26px;
            font-weight: 700;
            color: #17323f;
            margin-bottom: 4px;
        }

        .stat-label {
            color: #64748b;
            font-size: 13px;
            font-weight: 500;
        }

        /* ================= TABLES ================= */
        .table-responsive {
            overflow-x: auto;
            margin-top: 15px;
            border-radius: 10px;
            border: 1px solid #e2e8f0;
            background: #ffffff;
            -webkit-overflow-scrolling: touch;
        }

        .table-responsive::-webkit-scrollbar {
            height: 6px;
        }
        .table-responsive::-webkit-scrollbar-track {
            background: #f1f5f9;
        }
        .table-responsive::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 3px;
        }
        .table-responsive::-webkit-scrollbar-thumb:hover {
            background: #94a3b8;
        }

        .orders-table {
            width: 100%;
            min-width: 870px;
            border-collapse: collapse;
            text-align: left;
        }

        .orders-table th {
            background: #f8fafc;
            padding: 12px 14px;
            color: #475569;
            font-size: 13px;
            font-weight: 600;
            border-bottom: 1px solid #e2e8f0;
            white-space: nowrap;
        }

        .orders-table td {
            padding: 12px 14px;
            border-bottom: 1px solid #f1f5f9;
            color: #334155;
            font-size: 13.5px;
            vertical-align: middle;
        }

        .orders-table tr:hover td {
            background: #fbfcfe;
        }

        .orders-table tr:last-child td {
            border-bottom: none;
        }

        .actions-btn-group {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            flex-wrap: nowrap;
            white-space: nowrap;
        }

        .status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-delivered {
            background: #dcfce7;
            color: #15803d;
        }

        .status-processing {
            background: #fef9c3;
            color: #a16207;
        }

        .status-pending {
            background: #f1f5f9;
            color: #475569;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }

        /* ================= FORMS ================= */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 7px;
            font-weight: 600;
            color: #334155;
            font-size: 13.5px;
        }

        .form-control {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            outline: none;
            font-size: 14.5px;
            font-family: inherit;
            color: #1e293b;
            box-sizing: border-box;
            background: #ffffff;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .form-control:focus {
            border-color: #28609d;
            box-shadow: 0 0 0 3px rgba(40,96,157,0.12);
        }

        .form-control[readonly] {
            background: #f8fafc;
            color: #64748b;
            cursor: not-allowed;
        }

        textarea.form-control {
            resize: vertical;
            min-height: 90px;
        }

        .val-msg {
            color: #dc3545;
            font-size: 12.5px;
            font-weight: 500;
            margin-top: 5px;
            display: block;
        }

        /* ================= ADDRESS CARD ================= */
        .address-card {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-left: 4px solid #28609d;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 28px;
        }

        .address-card h3 {
            font-size: 16px;
            color: #17323f;
            margin-bottom: 8px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .address-card p {
            color: #475569;
            margin: 0;
            line-height: 1.6;
            font-size: 14.5px;
        }

        /* ================= BUTTONS ================= */
        .save-btn {
            margin-top: 22px;
            padding: 13px 26px;
            background: #28609d;
            color: #ffffff;
            border: none;
            border-radius: 7px;
            cursor: pointer;
            font-size: 14.5px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s ease;
        }

        .save-btn:hover {
            background: #1d4b7c;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40,96,157,0.25);
        }

        /* RATE ORDER STYLES */
        .btn-rate-order {
            background: #fff8e1;
            color: #b78103;
            border: 1px solid #ffe082;
            padding: 5px 9px;
            border-radius: 6px;
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
            transition: all 0.2s ease;
        }
        .btn-rate-order:hover {
            background: #ffecb3;
            color: #8c6000;
            transform: translateY(-1px);
            box-shadow: 0 2px 6px rgba(183, 129, 3, 0.25);
        }
        .status-not-delivered {
            font-size: 11px;
            color: #94a3b8;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            padding: 4px 8px;
            border-radius: 6px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .btn-track-order {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 5px 9px;
            background: #eff6ff;
            color: #1d4ed8;
            border: 1px solid #bfdbfe;
            border-radius: 6px;
            font-size: 11.5px;
            font-weight: 600;
            text-decoration: none;
            white-space: nowrap;
            transition: all 0.15s ease;
        }
        .btn-track-order:hover {
            background: #dbeafe;
            color: #1e40af;
        }

        .btn-return-order {
            background: #fdf2f8;
            color: #be185d;
            border: 1px solid #fbcfe8;
            padding: 5px 9px;
            border-radius: 6px;
            font-size: 11.5px;
            font-weight: 700;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
            transition: all 0.2s ease;
        }
        .btn-return-order:hover {
            background: #fce7f3;
            color: #9d174d;
            transform: translateY(-1px);
            box-shadow: 0 2px 6px rgba(190, 24, 93, 0.2);
        }

        .badge-return {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }
        .badge-return.return-pending {
            background: #ffedd5;
            color: #c2410c;
            border: 1px solid #fed7aa;
        }
        .badge-return.return-approved {
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }
        .badge-return.return-rejected {
            background: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }
        .badge-return.return-completed {
            background: #e0e7ff;
            color: #4338ca;
            border: 1px solid #c7d2fe;
        }

        /* RATE & RETURN MODAL */
        .rate-modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.55);
            backdrop-filter: blur(4px);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }
        .rate-modal-overlay.open {
            display: flex;
        }
        .rate-modal-box {
            background: #ffffff;
            border-radius: 14px;
            width: 90%;
            max-width: 480px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.2);
            overflow: hidden;
            animation: modalPop 0.25s ease;
        }
        @keyframes modalPop {
            from { transform: scale(0.95); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }
        .rate-modal-header {
            padding: 18px 24px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .rate-modal-header h3 {
            margin: 0;
            font-size: 17px;
            color: #1e293b;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .rate-close-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: #94a3b8;
            cursor: pointer;
            line-height: 1;
        }
        .rate-close-btn:hover {
            color: #1e293b;
        }
        .rate-modal-body {
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .rate-field-group label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #475569;
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        .rate-input-ctrl {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            box-sizing: border-box;
            background: #ffffff;
            color: #1e293b;
        }
        .rate-input-ctrl:focus {
            border-color: #28609d;
            box-shadow: 0 0 0 3px rgba(40,96,157,0.15);
        }
        .star-rating-bar {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .star-btn {
            font-size: 26px;
            color: #cbd5e1;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .star-btn.active {
            color: #f59e0b;
        }
        .star-btn:hover {
            transform: scale(1.15);
        }
        .star-score-text {
            margin-left: 10px;
            font-size: 13px;
            font-weight: 700;
            color: #475569;
        }
        .rate-modal-footer {
            padding: 16px 24px;
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .btn-rate-cancel {
            padding: 9px 18px;
            background: #e2e8f0;
            color: #475569;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 13px;
            cursor: pointer;
        }
        .btn-rate-submit {
            padding: 9px 20px;
            background: #28609d;
            color: #ffffff;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            font-size: 13px;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(40,96,157,0.25);
        }
        .btn-rate-submit:hover {
            background: #1d4b7c;
        }

        .empty-state {
            text-align: center;
            padding: 45px 20px;
            color: #64748b;
        }

        .empty-state i {
            font-size: 40px;
            color: #cbd5e1;
            margin-bottom: 12px;
            display: block;
        }

        .empty-state p {
            margin: 0 0 15px;
            font-size: 15px;
        }

        .empty-btn {
            display: inline-block;
            background: #28609d;
            color: #ffffff;
            padding: 9px 18px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13.5px;
            font-weight: 600;
        }

        /* ================= RESPONSIVE ================= */
        @media screen and (max-width: 950px) {
            .profile-layout {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
        }

        @media screen and (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .profile-container {
                width: 93%;
            }
            .profile-section {
                padding: 22px 18px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <section class="profile-page">
        <div class="profile-container">

            <!-- PAGE HEADER -->
            <div class="profile-header">
                <h1>My Account Panel</h1>
                <p>Manage your profile details, tracked orders, shipping addresses and security.</p>
            </div>

            <!-- ALERT BANNER -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false">
                <i class="fa-solid fa-circle-info"></i>
                <asp:Label ID="lblAlertMessage" runat="server"></asp:Label>
            </asp:Panel>

            <asp:HiddenField ID="hfActiveTab" runat="server" Value="dashboard" />

            <div class="profile-layout">

                <!-- ================= LEFT SIDEBAR ================= -->
                <aside class="profile-sidebar">
                    <div class="profile-image-box">
                        <img id="profileImage" class="profile-image"
                             src="https://ui-avatars.com/api/?name=User&background=28609d&color=fff&size=200"
                             alt="Profile Image" />
                        <button type="button" class="upload-btn" title="Change Photo"
                                onclick="document.getElementById('imageUpload').click()">
                            <i class="fa-solid fa-camera"></i>
                        </button>
                        <input type="file" id="imageUpload" accept="image/*" style="display:none;" onchange="changeProfileImage(event)" />
                    </div>

                    <div class="profile-name">
                        <asp:Label ID="lblProfileName" runat="server">User Name</asp:Label>
                    </div>
                    <div class="profile-email">
                        <asp:Label ID="lblProfileEmail" runat="server">user@email.com</asp:Label>
                    </div>

                    <!-- PROFILE TABS MENU -->
                    <div class="profile-menu">
                        <button type="button" class="menu-btn active" id="tab-dashboard" onclick="switchTab('dashboard', this)">
                            <i class="fa-solid fa-chart-line"></i> Dashboard
                        </button>

                        <button type="button" class="menu-btn" id="tab-profile" onclick="switchTab('profile', this)">
                            <i class="fa-solid fa-user"></i> My Profile
                        </button>

                        <button type="button" class="menu-btn" id="tab-orders" onclick="switchTab('orders', this)">
                            <i class="fa-solid fa-box-open"></i> My Orders
                        </button>

                        <button type="button" class="menu-btn" id="tab-address" onclick="switchTab('address', this)">
                            <i class="fa-solid fa-location-dot"></i> Delivery Address
                        </button>

                        <button type="button" class="menu-btn" id="tab-password" onclick="switchTab('password', this)">
                            <i class="fa-solid fa-key"></i> Change Password
                        </button>

                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="menu-link logout-link" OnClick="btnLogout_Click" CausesValidation="false">
                            <i class="fa-solid fa-right-from-bracket"></i> Sign Out
                        </asp:LinkButton>
                    </div>
                </aside>

                <!-- ================= CONTENT SECTIONS ================= -->
                <main class="profile-content">

                    <!-- 1. DASHBOARD TAB -->
                    <div id="section-dashboard" class="profile-section active-section">
                        <h2 class="section-title">
                            <i class="fa-solid fa-chart-line"></i> Account Dashboard
                        </h2>
                        <p class="section-description">
                            Welcome back! Overview of your shopping activity and recent orders.
                        </p>

                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-icon"><i class="fa-solid fa-bag-shopping"></i></div>
                                <div class="stat-number"><asp:Label ID="lblTotalOrders" runat="server">0</asp:Label></div>
                                <div class="stat-label">Total Orders</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon"><i class="fa-solid fa-circle-check"></i></div>
                                <div class="stat-number"><asp:Label ID="lblDeliveredOrders" runat="server">0</asp:Label></div>
                                <div class="stat-label">Delivered</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                                <div class="stat-number"><asp:Label ID="lblProcessingOrders" runat="server">0</asp:Label></div>
                                <div class="stat-label">Processing</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                                <div class="stat-number"><asp:Label ID="lblTotalSpent" runat="server">&#8377;0</asp:Label></div>
                                <div class="stat-label">Total Spent</div>
                            </div>
                        </div>

                        <h3 class="section-title" style="font-size:18px; margin-top:20px;">
                            <i class="fa-solid fa-clock"></i> Recent Orders
                        </h3>

                        <div class="table-responsive">
                            <table class="orders-table">
                                <thead>
                                    <tr>
                                        <th style="width: 120px; white-space: nowrap;">Order ID</th>
                                        <th style="width: 130px; white-space: nowrap;">Date</th>
                                        <th style="min-width: 130px; white-space: nowrap;">Recipient</th>
                                        <th style="width: 100px; white-space: nowrap;">Total</th>
                                        <th style="width: 110px; white-space: nowrap;">Status</th>
                                        <th style="min-width: 260px; width: 260px; white-space: nowrap;">Actions &amp; Rating</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentOrders" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="white-space: nowrap;"><a href='tracking.aspx?order=<%# Eval("order_number") %>' style='color:#1967d2; font-weight:700; text-decoration:none;' title='Track order'><i class='fa-solid fa-location-crosshairs' style='font-size:12px; margin-right:4px;'></i><%# Eval("order_number") %></a></td>
                                                <td style="white-space: nowrap;"><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy") %></td>
                                                <td style="white-space: nowrap; font-weight:600;"><%# Eval("customer_name") %></td>
                                                <td style="white-space: nowrap;"><strong>&#8377;<%# String.Format("{0:N0}", Eval("total_amount")) %></strong></td>
                                                <td style="white-space: nowrap;">
                                                    <span class='<%# "status status-" + Eval("order_status").ToString().ToLower() %>'>
                                                        <%# Eval("order_status") %>
                                                    </span>
                                                </td>
                                                <td style="white-space: nowrap;">
                                                    <div class="actions-btn-group">
                                                        <a href='tracking.aspx?order=<%# Eval("order_number") %>' class="btn-track-order" title="Track order"><i class='fa-solid fa-location-crosshairs'></i> Track</a>
                                                        <%# IsOrderDelivered(Eval("order_status")) 
                                                            ? "<button type='button' class='btn-rate-order' onclick=\"openRateModal('" + Eval("order_number") + "', '" + CleanJs(Eval("product_names")) + "')\"><i class='fa-solid fa-star'></i> Rate</button>" 
                                                            : "<span class='status-not-delivered'><i class='fa-solid fa-clock'></i> Delivered only</span>" %>
                                                        <%# GetReturnButtonOrBadge(Eval("order_number"), Eval("id"), Eval("product_names"), Eval("total_amount"), Eval("order_status"), Eval("return_status")) %>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoRecentOrders" runat="server" CssClass="empty-state" Visible="false">
                                <i class="fa-solid fa-box-open"></i>
                                <p>No orders placed yet.</p>
                                <a href="product.aspx" class="empty-btn"><i class="fa-solid fa-bag-shopping"></i> Browse Men's Collection</a>
                            </asp:Panel>
                        </div>
                    </div>


                    <!-- 2. MY PROFILE TAB -->
                    <div id="section-profile" class="profile-section">
                        <h2 class="section-title">
                            <i class="fa-solid fa-user-pen"></i> Personal Information
                        </h2>
                        <p class="section-description">
                            Update your personal profile details. All inputs use ASP.NET server validation.
                        </p>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                                    ControlToValidate="txtFirstName"
                                    ErrorMessage="First name is required."
                                    ValidationGroup="ProfileGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>Last Name</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                                    ControlToValidate="txtLastName"
                                    ErrorMessage="Last name is required."
                                    ValidationGroup="ProfileGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>Email Address (Account ID)</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label>Phone Number (10 Digits)</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="e.g. 9876543210"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvProfilePhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ErrorMessage="Phone number is required."
                                    ValidationGroup="ProfileGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                                <asp:RegularExpressionValidator ID="revProfilePhone" runat="server"
                                    ControlToValidate="txtPhone"
                                    ValidationExpression="^[0-9]{10}$"
                                    ErrorMessage="Phone number must be exactly 10 digits."
                                    ValidationGroup="ProfileGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>Gender</label>
                                <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="Male">Male</asp:ListItem>
                                    <asp:ListItem Value="Female">Female</asp:ListItem>
                                    <asp:ListItem Value="Other">Other</asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="form-group full-width">
                                <label>About Me (Bio)</label>
                                <asp:TextBox ID="txtBio" runat="server" TextMode="MultiLine" CssClass="form-control" placeholder="Share a few words about your fashion style..."></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btnSaveProfile" runat="server"
                            Text="Save Profile Changes"
                            CssClass="save-btn"
                            ValidationGroup="ProfileGroup"
                            CausesValidation="true"
                            OnClick="btnSaveProfile_Click" />
                    </div>


                    <!-- 3. MY ORDERS TAB -->
                    <div id="section-orders" class="profile-section">
                        <h2 class="section-title">
                            <i class="fa-solid fa-box-open"></i> Order History
                        </h2>
                        <p class="section-description">
                            Review and track all your previous purchases with current fulfillment status.
                        </p>

                        <div class="table-responsive">
                            <table class="orders-table">
                                <thead>
                                    <tr>
                                        <th style="width: 120px; white-space: nowrap;">Order ID</th>
                                        <th style="width: 150px; white-space: nowrap;">Order Date</th>
                                        <th style="min-width: 130px; white-space: nowrap;">Recipient</th>
                                        <th style="width: 100px; white-space: nowrap;">Total Amount</th>
                                        <th style="width: 110px; white-space: nowrap;">Status</th>
                                        <th style="min-width: 260px; width: 260px; white-space: nowrap;">Actions &amp; Rating</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <asp:Repeater ID="rptAllOrders" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="white-space: nowrap;"><a href='tracking.aspx?order=<%# Eval("order_number") %>' style='color:#1967d2; font-weight:700; text-decoration:none;' title='Track order'><i class='fa-solid fa-location-crosshairs' style='font-size:12px; margin-right:4px;'></i><%# Eval("order_number") %></a></td>
                                                <td style="white-space: nowrap;"><%# Convert.ToDateTime(Eval("created_at")).ToString("dd MMM yyyy, hh:mm tt") %></td>
                                                <td style="white-space: nowrap; font-weight:600;"><%# Eval("customer_name") %></td>
                                                <td style="white-space: nowrap;"><strong>&#8377;<%# String.Format("{0:N0}", Eval("total_amount")) %></strong></td>
                                                <td style="white-space: nowrap;">
                                                    <span class='<%# "status status-" + Eval("order_status").ToString().ToLower() %>'>
                                                         <%# Eval("order_status") %>
                                                    </span>
                                                </td>
                                                <td style="white-space: nowrap;">
                                                    <div class="actions-btn-group">
                                                        <a href='tracking.aspx?order=<%# Eval("order_number") %>' class="btn-track-order" title="Track order"><i class='fa-solid fa-location-crosshairs'></i> Track</a>
                                                        <%# IsOrderDelivered(Eval("order_status")) 
                                                            ? "<button type='button' class='btn-rate-order' onclick=\"openRateModal('" + Eval("order_number") + "', '" + CleanJs(Eval("product_names")) + "')\"><i class='fa-solid fa-star'></i> Rate</button>" 
                                                            : "<span class='status-not-delivered'><i class='fa-solid fa-clock'></i> Delivered only</span>" %>
                                                        <%# GetReturnButtonOrBadge(Eval("order_number"), Eval("id"), Eval("product_names"), Eval("total_amount"), Eval("order_status"), Eval("return_status")) %>
                                                    </div>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlNoAllOrders" runat="server" CssClass="empty-state" Visible="false">
                                <i class="fa-solid fa-bag-shopping"></i>
                                <p>You have not placed any orders yet.</p>
                                <a href="product.aspx" class="empty-btn"><i class="fa-solid fa-cart-plus"></i> Shop Men's Fashion</a>
                            </asp:Panel>
                        </div>
                    </div>


                    <!-- 4. ADDRESS TAB -->
                    <div id="section-address" class="profile-section">
                        <h2 class="section-title">
                            <i class="fa-solid fa-location-dot"></i> Delivery Address
                        </h2>
                        <p class="section-description">
                            Manage your saved shipping address used for fast checkouts.
                        </p>

                        <div class="address-card">
                            <h3><i class="fa-solid fa-house"></i> Default Shipping Address</h3>
                            <p>
                                <asp:Label ID="lblDisplayAddress" runat="server">No address saved yet.</asp:Label>
                            </p>
                        </div>

                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label>Street Address / House / Flat</label>
                                <asp:TextBox ID="txtAddressLine" runat="server" CssClass="form-control" placeholder="House/Flat No., Building Name, Street/Area"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvAddressLine" runat="server"
                                    ControlToValidate="txtAddressLine"
                                    ErrorMessage="Street address is required."
                                    ValidationGroup="AddressGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>City</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="City"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCity" runat="server"
                                    ControlToValidate="txtCity"
                                    ErrorMessage="City is required."
                                    ValidationGroup="AddressGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>State</label>
                                <asp:TextBox ID="txtState" runat="server" CssClass="form-control" placeholder="State"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvState" runat="server"
                                    ControlToValidate="txtState"
                                    ErrorMessage="State is required."
                                    ValidationGroup="AddressGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>PIN Code (6 Digits)</label>
                                <asp:TextBox ID="txtPincode" runat="server" CssClass="form-control" placeholder="6-digit PIN code"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPincode" runat="server"
                                    ControlToValidate="txtPincode"
                                    ErrorMessage="PIN code is required."
                                    ValidationGroup="AddressGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                                <asp:RegularExpressionValidator ID="revPincode" runat="server"
                                    ControlToValidate="txtPincode"
                                    ValidationExpression="^[0-9]{6}$"
                                    ErrorMessage="PIN code must be exactly 6 digits."
                                    ValidationGroup="AddressGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group">
                                <label>Country</label>
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" Text="India"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button ID="btnSaveAddress" runat="server"
                            Text="Save Delivery Address"
                            CssClass="save-btn"
                            ValidationGroup="AddressGroup"
                            CausesValidation="true"
                            OnClick="btnSaveAddress_Click" />
                    </div>


                    <!-- 5. CHANGE PASSWORD TAB -->
                    <div id="section-password" class="profile-section">
                        <h2 class="section-title">
                            <i class="fa-solid fa-key"></i> Change Password
                        </h2>
                        <p class="section-description">
                            Keep your account secure with a strong password.
                        </p>

                        <div style="max-width: 500px;">
                            <div class="form-group" style="margin-bottom: 16px;">
                                <label>Current Password</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server"
                                    ControlToValidate="txtCurrentPassword"
                                    ErrorMessage="Current password is required."
                                    ValidationGroup="PasswordGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label>New Password (Min 6 Characters)</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                                    ControlToValidate="txtNewPassword"
                                    ErrorMessage="New password is required."
                                    ValidationGroup="PasswordGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                                <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                                    ControlToValidate="txtNewPassword"
                                    ValidationExpression="^.{6,}$"
                                    ErrorMessage="New password must be at least 6 characters long."
                                    ValidationGroup="PasswordGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <div class="form-group" style="margin-bottom: 16px;">
                                <label>Confirm New Password</label>
                                <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter new password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvConfirmNewPassword" runat="server"
                                    ControlToValidate="txtConfirmNewPassword"
                                    ErrorMessage="Please confirm your new password."
                                    ValidationGroup="PasswordGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                                <asp:CompareValidator ID="cvConfirmNewPassword" runat="server"
                                    ControlToValidate="txtConfirmNewPassword"
                                    ControlToCompare="txtNewPassword"
                                    ErrorMessage="New password and Confirm password do not match."
                                    ValidationGroup="PasswordGroup"
                                    ForeColor="#dc3545" Display="Dynamic" CssClass="val-msg" />
                            </div>

                            <asp:Button ID="btnChangePassword" runat="server"
                                Text="Update Password"
                                CssClass="save-btn"
                                ValidationGroup="PasswordGroup"
                                CausesValidation="true"
                                OnClick="btnChangePassword_Click" />
                        </div>
                    </div>

                </main>
            </div>
        </div>
    </section>

    <script>
        function switchTab(tabName, btn) {
            document.querySelectorAll(".profile-section").forEach(function(sec) {
                sec.classList.remove("active-section");
            });

            var targetSec = document.getElementById("section-" + tabName);
            if (targetSec) {
                targetSec.classList.add("active-section");
            }

            document.querySelectorAll(".profile-menu button").forEach(function(b) {
                b.classList.remove("active");
            });

            if (btn) {
                btn.classList.add("active");
            } else {
                var autoBtn = document.getElementById("tab-" + tabName);
                if (autoBtn) autoBtn.classList.add("active");
            }

            var hf = document.getElementById("<%= hfActiveTab.ClientID %>");
            if (hf) {
                hf.value = tabName;
            }
        }

        function changeProfileImage(event) {
            var file = event.target.files[0];
            if (!file) return;

            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.getElementById("profileImage");
                if (img) img.src = e.target.result;
                try {
                    localStorage.setItem("user_profile_img", e.target.result);
                } catch(err) {}
            };
            reader.readAsDataURL(file);
        }

        document.addEventListener("DOMContentLoaded", function() {
            var hf = document.getElementById("<%= hfActiveTab.ClientID %>");
            var currentTab = (hf && hf.value) ? hf.value : "dashboard";
            switchTab(currentTab);

            var savedImg = localStorage.getItem("user_profile_img");
            if (savedImg) {
                var img = document.getElementById("profileImage");
                if (img) img.src = savedImg;
            }
        });

        // ================= RATE PRODUCT MODAL JS =================
        function openRateModal(orderNumber, productNamesStr) {
            var hfOrder = document.getElementById('<%= hfRateOrderNumber.ClientID %>');
            if (hfOrder) hfOrder.value = orderNumber;

            var subtitle = document.getElementById('rateModalSubTitle');
            if (subtitle) subtitle.innerText = 'Order #' + orderNumber + ' (Delivered)';

            var selectElem = document.getElementById('rateProductSelect');
            var hfProd = document.getElementById('<%= hfRateProductName.ClientID %>');
            if (selectElem) {
                selectElem.innerHTML = '';
                var items = (productNamesStr || '').split('|');
                var count = 0;
                var firstVal = '';
                items.forEach(function (it) {
                    it = it.trim();
                    if (it) {
                        var opt = document.createElement('option');
                        opt.value = it;
                        opt.text = it;
                        selectElem.appendChild(opt);
                        if (!firstVal) firstVal = it;
                        count++;
                    }
                });
                if (count === 0) {
                    var opt = document.createElement('option');
                    opt.value = 'Garment Product';
                    opt.text = 'Garment Product';
                    selectElem.appendChild(opt);
                    firstVal = 'Garment Product';
                }
                if (hfProd) hfProd.value = firstVal;
            }

            setRating(5);
            var comment = document.getElementById('<%= txtRateComment.ClientID %>');
            if (comment) comment.value = '';

            var modal = document.getElementById('rateModal');
            if (modal) modal.classList.add('open');
        }

        function closeRateModal() {
            var modal = document.getElementById('rateModal');
            if (modal) modal.classList.remove('open');
        }

        function setRating(val) {
            var hf = document.getElementById('<%= hfRatingScore.ClientID %>');
            if (hf) hf.value = val;

            var stars = document.querySelectorAll('#starRatingContainer .star-btn');
            stars.forEach(function (s) {
                var sVal = parseInt(s.getAttribute('data-val'), 10);
                if (sVal <= val) {
                    s.classList.add('active');
                } else {
                    s.classList.remove('active');
                }
            });

            var labels = {
                1: '1.0 / 5.0 (Poor)',
                2: '2.0 / 5.0 (Fair)',
                3: '3.0 / 5.0 (Good)',
                4: '4.0 / 5.0 (Very Good)',
                5: '5.0 / 5.0 (Excellent)'
            };
            var lbl = document.getElementById('lblStarScore');
            if (lbl && labels[val]) lbl.innerText = labels[val];
        }

        function openReturnModal(orderNum, orderId, prods, totalAmount) {
            var hfNum = document.getElementById('<%= hfReturnOrderNumber.ClientID %>');
            var hfId = document.getElementById('<%= hfReturnOrderId.ClientID %>');
            var hfProds = document.getElementById('<%= hfReturnProductNames.ClientID %>');
            var hfAmt = document.getElementById('<%= hfReturnTotalAmount.ClientID %>');

            if (hfNum) hfNum.value = orderNum;
            if (hfId) hfId.value = orderId;
            if (hfProds) hfProds.value = prods;
            if (hfAmt) hfAmt.value = totalAmount;

            var txtNum = document.getElementById('returnModalOrderNum');
            var txtProds = document.getElementById('returnModalProducts');
            var txtAmt = document.getElementById('returnModalAmount');

            if (txtNum) txtNum.innerText = '#' + orderNum;
            if (txtProds) txtProds.innerText = prods || 'Garment Items';
            if (txtAmt) txtAmt.innerText = '₹' + totalAmount;

            var comment = document.getElementById('<%= txtReturnComments.ClientID %>');
            if (comment) comment.value = '';

            var modal = document.getElementById('returnModal');
            if (modal) modal.classList.add('open');
        }

        function closeReturnModal() {
            var modal = document.getElementById('returnModal');
            if (modal) modal.classList.remove('open');
        }
    </script>

    <!-- ================= RATE PRODUCT MODAL (DELIVERED ORDERS ONLY) ================= -->
    <div id="rateModal" class="rate-modal-overlay">
        <div class="rate-modal-box">
            <div class="rate-modal-header">
                <div>
                    <h3><i class="fa-solid fa-star" style="color: #f59e0b;"></i> Rate &amp; Review Product</h3>
                    <p id="rateModalSubTitle" style="font-size: 12px; color: #64748b; margin-top: 4px;">Delivered Order Rating</p>
                </div>
                <button type="button" class="rate-close-btn" onclick="closeRateModal()">&times;</button>
            </div>
            <div class="rate-modal-body">
                <asp:HiddenField ID="hfRateOrderNumber" runat="server" />
                <asp:HiddenField ID="hfRatingScore" runat="server" Value="5" />
                <asp:HiddenField ID="hfRateProductName" runat="server" />

                <div class="rate-field-group">
                    <label>Select Purchased Product</label>
                    <select id="rateProductSelect" class="rate-input-ctrl" onchange="var hf=document.getElementById('<%= hfRateProductName.ClientID %>'); if(hf) hf.value=this.value;"></select>
                </div>

                <div class="rate-field-group">
                    <label>Your Rating</label>
                    <div class="star-rating-bar" id="starRatingContainer">
                        <i class="fa-solid fa-star star-btn active" data-val="1" onclick="setRating(1)"></i>
                        <i class="fa-solid fa-star star-btn active" data-val="2" onclick="setRating(2)"></i>
                        <i class="fa-solid fa-star star-btn active" data-val="3" onclick="setRating(3)"></i>
                        <i class="fa-solid fa-star star-btn active" data-val="4" onclick="setRating(4)"></i>
                        <i class="fa-solid fa-star star-btn active" data-val="5" onclick="setRating(5)"></i>
                        <span id="lblStarScore" class="star-score-text">5.0 / 5.0 (Excellent)</span>
                    </div>
                </div>

                <div class="rate-field-group">
                    <label>Write Review / Feedback</label>
                    <asp:TextBox ID="txtRateComment" runat="server" TextMode="MultiLine" Rows="3" CssClass="rate-input-ctrl" placeholder="Share your experience about the fabric quality, stitching, and fit..."></asp:TextBox>
                </div>
            </div>
            <div class="rate-modal-footer">
                <button type="button" class="btn-rate-cancel" onclick="closeRateModal()">Cancel</button>
                <asp:Button ID="btnSubmitRating" runat="server" Text="Submit Review" CssClass="btn-rate-submit" OnClick="btnSubmitRating_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <!-- ================= RETURN ORDER MODAL (DELIVERED/COMPLETED ORDERS ONLY) ================= -->
    <div id="returnModal" class="rate-modal-overlay">
        <div class="rate-modal-box">
            <div class="rate-modal-header">
                <div>
                    <h3><i class="fa-solid fa-rotate-left" style="color: #be185d;"></i> Return Order Request</h3>
                    <p style="font-size: 12px; color: #64748b; margin-top: 4px;">Return &amp; Refund Request</p>
                </div>
                <button type="button" class="rate-close-btn" onclick="closeReturnModal()">&times;</button>
            </div>
            <div class="rate-modal-body">
                <asp:HiddenField ID="hfReturnOrderNumber" runat="server" />
                <asp:HiddenField ID="hfReturnOrderId" runat="server" />
                <asp:HiddenField ID="hfReturnProductNames" runat="server" />
                <asp:HiddenField ID="hfReturnTotalAmount" runat="server" />

                <div style="background: #fdf2f8; border: 1px solid #fbcfe8; border-radius: 8px; padding: 12px 14px;">
                    <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 4px;">
                        <span style="color: #64748b; font-weight: 600;">Order ID:</span>
                        <strong id="returnModalOrderNum" style="color: #1e293b;">#ORD-000000</strong>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 13px; margin-bottom: 4px;">
                        <span style="color: #64748b; font-weight: 600;">Eligible Refund:</span>
                        <strong id="returnModalAmount" style="color: #be185d; font-weight: 800;">₹0</strong>
                    </div>
                    <div style="font-size: 12px; color: #64748b; margin-top: 6px; border-top: 1px dashed #fbcfe8; padding-top: 6px;">
                        <span style="font-weight: 600;">Items:</span> <span id="returnModalProducts">Garment Item</span>
                    </div>
                </div>

                <div class="rate-field-group">
                    <label>Reason for Return</label>
                    <asp:DropDownList ID="ddlReturnReason" runat="server" CssClass="rate-input-ctrl">
                        <asp:ListItem Value="Size / Fit Issue">Size / Fit Issue</asp:ListItem>
                        <asp:ListItem Value="Defective / Damaged Item">Defective / Damaged Item</asp:ListItem>
                        <asp:ListItem Value="Wrong Item Received">Wrong Item Received</asp:ListItem>
                        <asp:ListItem Value="Quality Not as Expected">Quality Not as Expected</asp:ListItem>
                        <asp:ListItem Value="Changed Mind">Changed Mind</asp:ListItem>
                        <asp:ListItem Value="Other">Other</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="rate-field-group">
                    <label>Additional Comments / Notes (Optional)</label>
                    <asp:TextBox ID="txtReturnComments" runat="server" TextMode="MultiLine" Rows="3" CssClass="rate-input-ctrl" placeholder="Please provide any extra details regarding this return request..."></asp:TextBox>
                </div>
            </div>
            <div class="rate-modal-footer">
                <button type="button" class="btn-rate-cancel" onclick="closeReturnModal()">Cancel</button>
                <asp:Button ID="btnSubmitReturnOrder" runat="server" Text="Submit Return Request" CssClass="btn-rate-submit" Style="background:#be185d;" OnClick="btnSubmitReturnOrder_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>