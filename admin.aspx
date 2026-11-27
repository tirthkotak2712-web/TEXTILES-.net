<%@ Page Title="Admin Panel" Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="textiles.admin" ResponseEncoding="utf-8" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>TEXTILES Admin Panel - Men's Clothing Store Management</title>

    <!-- Google Fonts & Font Awesome 6 -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" />

    <style>
        :root {
            --primary: #1565c0;
            --primary-dark: #0d47a1;
            --primary-light: #e3f2fd;
            --primary-border: #90caf9;
            --primary-gradient: linear-gradient(135deg, #1976d2 0%, #1565c0 100%);
            --sidebar-bg: #1565c0;
            --main-bg: #f0f7ff;
            --card-bg: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --border-light: #dbeafe;
            --radius-card: 16px;
            --radius-pill: 12px;
            --shadow-subtle: 0 4px 20px rgba(21, 101, 192, 0.05);
            --shadow-hover: 0 10px 25px -5px rgba(21, 101, 192, 0.1);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--main-bg);
            color: var(--text-main);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        /* ================= SIDEBAR ================= */
        .admin-sidebar {
            width: 250px;
            background-color: var(--sidebar-bg);
            border-right: 1px solid rgba(255, 255, 255, 0.15);
            display: flex;
            flex-direction: column;
            position: fixed;
            left: 0;
            top: 0;
            bottom: 0;
            z-index: 1000;
            overflow-y: auto;
            scrollbar-width: thin;
        }

        .admin-sidebar::-webkit-scrollbar {
            width: 4px;
        }
        .admin-sidebar::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.3);
            border-radius: 4px;
        }

        /* Brand Header */
        .sidebar-brand {
            padding: 24px 20px 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
        }

        .sidebar-brand-icon {
            width: 42px;
            height: 42px;
            background: #ffffff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary);
            font-size: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }

        .sidebar-brand-title {
            font-size: 21px;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.5px;
        }

        /* Profile Card */
        .sidebar-profile {
            background: rgba(255, 255, 255, 0.14);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: var(--radius-pill);
            padding: 10px 14px;
            margin: 12px 14px 14px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .sidebar-profile-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #ffffff;
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            font-weight: 800;
            flex-shrink: 0;
        }

        .sidebar-profile-info {
            overflow: hidden;
        }

        .sidebar-profile-name {
            font-size: 13.5px;
            font-weight: 700;
            color: #ffffff;
            line-height: 1.2;
        }

        .sidebar-profile-role {
            font-size: 11px;
            color: #bfdbfe;
        }

        /* Menu Groups */
        .sidebar-nav {
            list-style: none;
            padding: 0 0 20px;
            flex: 1;
        }

        .nav-category {
            font-size: 10.5px;
            font-weight: 800;
            letter-spacing: 0.8px;
            color: #bfdbfe;
            padding: 16px 20px 6px;
            text-transform: uppercase;
        }

        .sidebar-nav li {
            margin: 2px 0;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 9.5px 16px;
            margin: 2px 14px;
            border-radius: 10px;
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            transition: all 0.15s ease;
            position: relative;
        }

        .sidebar-nav a i {
            width: 18px;
            text-align: center;
            font-size: 14px;
            color: #bfdbfe;
            transition: color 0.15s ease;
        }

        .sidebar-nav a:hover {
            background-color: rgba(255, 255, 255, 0.16);
            color: #ffffff;
        }

        .sidebar-nav a:hover i {
            color: #ffffff;
        }

        .sidebar-nav a.active {
            background: #ffffff;
            color: var(--primary);
            box-shadow: 0 4px 14px rgba(0, 0, 0, 0.15);
            font-weight: 700;
        }

        .sidebar-nav a.active i {
            color: var(--primary);
        }

        .nav-badge-orange {
            margin-left: auto;
            background: #ffedd5;
            color: #c2410c;
            font-size: 11px;
            font-weight: 700;
            padding: 1px 7px;
            border-radius: 10px;
        }

        .sidebar-footer {
            padding: 14px 16px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
        }

        .sidebar-footer a {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ffffff;
            background: rgba(239, 68, 68, 0.85);
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            padding: 10px 14px;
            border-radius: 10px;
            transition: background 0.15s;
        }

        .sidebar-footer a:hover {
            background: #dc2626;
            color: #ffffff;
        }

        .input-error {
            border-color: #ef4444 !important;
            background-color: #fef2f2 !important;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.2) !important;
        }

        .validation-error-banner {
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13.5px;
            font-weight: 700;
            margin-bottom: 18px;
            display: none;
            align-items: center;
            gap: 10px;
        }

        /* ================= MAIN CONTENT ================= */
        .admin-main {
            margin-left: 250px;
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Top Header */
        .admin-header {
            padding: 24px 32px 18px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-title-box h1 {
            font-size: 17px;
            font-weight: 700;
            color: var(--text-main);
            letter-spacing: -0.2px;
        }

        .header-title-box p {
            font-size: 12.5px;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 18px;
        }

        .header-bell {
            color: #64748b;
            font-size: 16px;
            cursor: pointer;
            position: relative;
        }

        .header-bell::after {
            content: '';
            position: absolute;
            top: -2px;
            right: -2px;
            width: 6px;
            height: 6px;
            background: #ef4444;
            border-radius: 50%;
        }

        .header-welcome {
            font-size: 13px;
            font-weight: 600;
            color: #475569;
        }

        /* Content Container */
        .admin-content-area {
            padding: 0 32px 60px;
            flex: 1;
        }

        .admin-view {
            display: none;
            animation: fadeIn 0.2s ease-in-out;
        }

        .admin-view.active {
            display: block;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(4px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .view-page-title {
            font-size: 24px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 22px;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.4px;
        }

        .view-page-title i {
            color: var(--primary);
        }

        /* Alert Toast */
        .admin-alert-banner {
            display: block;
            padding: 12px 18px;
            border-radius: 12px;
            margin-bottom: 22px;
            font-size: 13.5px;
            font-weight: 600;
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }

        /* ================= 6 STAT CARDS (IMAGE 1) ================= */
        .stat-cards-six-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 28px;
        }

        @media (max-width: 1200px) {
            .stat-cards-six-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        .stat-card-clean {
            background: var(--card-bg);
            border-radius: var(--radius-card);
            padding: 22px 24px;
            box-shadow: var(--shadow-subtle);
            border: 1px solid #f1f5f9;
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .stat-card-clean:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .stat-card-num {
            font-size: 28px;
            font-weight: 800;
            color: var(--text-main);
            line-height: 1.1;
            letter-spacing: -0.5px;
        }

        .stat-card-label {
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
            margin-top: 5px;
        }

        .stat-card-squircle {
            width: 50px;
            height: 50px;
            border-radius: 14px;
            background: var(--primary-gradient);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: 0 6px 16px rgba(37, 99, 235, 0.28);
        }

        .stat-card-squircle.currency {
            font-family: inherit;
            font-weight: 800;
            font-size: 20px;
        }

        /* ================= WHITE CARDS & TABLES ================= */
        .white-box-card {
            background: var(--card-bg);
            border-radius: var(--radius-card);
            padding: 24px 26px;
            box-shadow: var(--shadow-subtle);
            border: 1px solid #f1f5f9;
            margin-bottom: 24px;
        }

        .card-header-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .card-header-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .card-header-title i {
            color: var(--primary);
        }

        .btn-view-all-pill {
            background: var(--primary-gradient);
            color: #ffffff !important;
            padding: 7px 18px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(37, 99, 235, 0.25);
            transition: opacity 0.15s;
        }

        .btn-view-all-pill:hover {
            opacity: 0.92;
        }

        /* Clean Table */
        .clean-table-responsive {
            width: 100%;
            overflow-x: auto;
        }

        .clean-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
        }

        .clean-table th {
            text-align: left;
            padding: 12px 14px;
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            border-bottom: 1px solid #e2e8f0;
            background: #fafbfd;
        }

        .clean-table td {
            padding: 14px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
            color: var(--text-main);
        }

        .clean-table tr:hover td {
            background-color: #f8fafc;
        }

        .table-id-bold {
            font-weight: 800;
            color: var(--text-main);
        }

        .table-cust-name {
            font-weight: 700;
            color: var(--text-main);
        }

        .table-cust-sub {
            font-size: 11.5px;
            color: var(--text-muted);
            margin-top: 1px;
        }

        .table-price-bold {
            font-weight: 800;
            color: #1e293b;
        }

        /* Soft Status Pills */
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 11.5px;
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .status-badge.pending {
            background: #ffedd5;
            color: #c2410c;
        }

        .status-badge.processing {
            background: #e0e7ff;
            color: #4338ca;
        }

        .status-badge.shipped {
            background: #e0f2fe;
            color: #0369a1;
        }

        .status-badge.completed {
            background: #dcfce7;
            color: #15803d;
        }

        .status-badge.cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-badge.cod {
            background: #dcfce7;
            color: #166534;
            font-weight: 800;
        }

        .badge-return {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 11.5px;
            font-weight: 700;
        }
        .badge-return.return-pending {
            background: #ffedd5;
            color: #c2410c;
        }
        .badge-return.return-approved {
            background: #dcfce7;
            color: #15803d;
        }
        .badge-return.return-rejected {
            background: #fee2e2;
            color: #b91c1c;
        }
        .badge-return.return-completed {
            background: #e0e7ff;
            color: #4338ca;
        }

        /* Action Dropdown inside table */
        .table-action-select {
            padding: 5px 10px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            background: #ffffff;
            font-size: 12.5px;
            font-weight: 600;
            color: #334155;
            outline: none;
            cursor: pointer;
            transition: border 0.15s;
        }

        .table-action-select:focus {
            border-color: var(--primary);
        }

        /* ================= ADD PRODUCT FORM (IMAGE 2) ================= */
        .form-grid-three {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 18px;
        }

        .form-grid-two {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 18px;
        }

        @media (max-width: 900px) {
            .form-grid-three, .form-grid-two {
                grid-template-columns: 1fr;
            }
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #334155;
        }

        .form-group label .req {
            color: #ef4444;
        }

        .form-control-input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 13.5px;
            font-family: inherit;
            color: var(--text-main);
            background: #ffffff;
            outline: none;
            transition: border 0.15s, box-shadow 0.15s;
        }

        .form-control-input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        textarea.form-control-input {
            resize: vertical;
            min-height: 90px;
        }

        /* Size-wise Stock Input Sub-card */
        .size-stock-input-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            padding: 18px 20px;
            margin-top: 14px;
            margin-bottom: 22px;
        }

        .size-stock-input-box h3 {
            font-size: 13.5px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 12px;
        }

        .size-stock-inputs-row {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 14px;
        }

        .size-stock-col {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .size-stock-col label {
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
        }

        .btn-submit-green {
            background: #10b981;
            color: #ffffff;
            font-size: 13.5px;
            font-weight: 700;
            padding: 10px 22px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: opacity 0.15s;
        }

        .btn-submit-green:hover {
            opacity: 0.92;
        }

        /* ================= MANAGE PRODUCTS CARDS GRID (IMAGE 3) ================= */
        .products-cards-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 22px;
        }

        @media (max-width: 1100px) {
            .products-cards-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        @media (max-width: 700px) {
            .products-cards-grid {
                grid-template-columns: 1fr;
            }
        }

        .prod-card {
            background: var(--card-bg);
            border-radius: var(--radius-card);
            border: 1px solid #edf2f7;
            box-shadow: var(--shadow-subtle);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .prod-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-hover);
        }

        .prod-card-thumb {
            width: 100%;
            height: 210px;
            object-fit: cover;
            background: #f1f5f9;
        }

        .prod-card-body {
            padding: 16px 18px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .prod-card-title {
            font-size: 15px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 4px;
        }

        .prod-card-price {
            font-size: 16px;
            font-weight: 800;
            color: var(--primary);
            margin-bottom: 12px;
        }

        .size-badges-row {
            display: flex;
            flex-wrap: wrap;
            gap: 5px;
            margin-bottom: 10px;
        }

        .size-badge-pill {
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 11px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 6px;
            border: 1px solid #dbeafe;
        }

        .stock-total-badge {
            background: #ecfdf5;
            color: #047857;
            font-size: 11.5px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 12px;
            display: inline-block;
            margin-bottom: 8px;
            width: fit-content;
        }

        .prod-card-rating {
            color: #f59e0b;
            font-size: 12.5px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .prod-card-rating span {
            color: #64748b;
            font-weight: 500;
            font-size: 11.5px;
        }

        .prod-card-actions {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: auto;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }

        .btn-card-details {
            background: var(--primary);
            color: #ffffff !important;
            padding: 6px 14px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        .select-card-status {
            padding: 5px 8px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            background: #ffffff;
            cursor: pointer;
        }

        .btn-card-delete {
            margin-left: auto;
            background: #ef4444;
            color: #ffffff !important;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }

        /* ================= SIZE-WISE STOCK CARDS (IMAGE 4) ================= */
        .stock-manage-card {
            background: var(--card-bg);
            border-radius: var(--radius-card);
            border: 1px solid #edf2f7;
            box-shadow: var(--shadow-subtle);
            padding: 20px 22px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .stock-card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }

        .stock-card-title {
            font-size: 15px;
            font-weight: 700;
            color: #1e293b;
        }

        .stock-card-sub {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .stock-card-total-pill {
            background: #eff6ff;
            color: var(--primary);
            font-size: 11.5px;
            font-weight: 800;
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid var(--primary-border);
        }

        .stock-section-title {
            font-size: 10.5px;
            font-weight: 800;
            letter-spacing: 0.6px;
            color: #94a3b8;
            text-transform: uppercase;
            margin-bottom: 8px;
        }

        .stock-adjust-form {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 14px;
            padding-top: 12px;
            border-top: 1px solid #f1f5f9;
        }

        .stock-select-size {
            padding: 6px 10px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            font-size: 12px;
            font-weight: 600;
            color: #334155;
            background: #ffffff;
            cursor: pointer;
            flex: 1;
        }

        .stock-input-qty {
            width: 50px;
            padding: 6px 8px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            font-size: 12.5px;
            font-weight: 700;
            text-align: center;
        }

        .btn-stock-add {
            background: #10b981;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
        }

        .btn-stock-remove {
            background: #f59e0b;
            color: #ffffff;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 700;
            border: none;
            cursor: pointer;
        }

        /* Modal Styles */
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(15, 23, 42, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 2000;
            padding: 20px;
        }

        .modal-overlay.open {
            display: flex;
        }

        .modal-box {
            background: #ffffff;
            border-radius: 16px;
            width: 100%;
            max-width: 580px;
            padding: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 18px;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 20px;
            color: #94a3b8;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <div class="admin-layout">

            <!-- ================= SIDEBAR ================= -->
            <aside class="admin-sidebar">
                <div class="sidebar-brand">
                    <div class="sidebar-brand-icon">
                        <i class="fa-solid fa-shirt"></i>
                    </div>
                    <div class="sidebar-brand-title">Textile</div>
                </div>

                <div class="sidebar-profile">
                    <div class="sidebar-profile-avatar">
                        <i class="fa-solid fa-user"></i>
                    </div>
                    <div class="sidebar-profile-info">
                        <div class="sidebar-profile-name">Admin</div>
                        <div class="sidebar-profile-role">Administrator</div>
                    </div>
                </div>

                <ul class="sidebar-nav">
                    <!-- OVERVIEW -->
                    <li class="nav-category">OVERVIEW</li>
                    <li>
                        <a href="javascript:void(0)" class="active" onclick="switchNav('dashboard', this)">
                            <i class="fa-solid fa-gauge-high"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>

                    <!-- CATALOG -->
                    <li class="nav-category">CATALOG</li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('addProduct', this)">
                            <i class="fa-solid fa-circle-plus"></i>
                            <span>Add Product</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('manageProducts', this)">
                            <i class="fa-solid fa-boxes-stacked"></i>
                            <span>Manage Products</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('categories', this)">
                            <i class="fa-solid fa-layer-group"></i>
                            <span>Categories &amp; Collections</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('sizeStock', this)">
                            <i class="fa-solid fa-warehouse"></i>
                            <span>Size-wise Stock</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('colors', this)">
                            <i class="fa-solid fa-palette"></i>
                            <span>Colors &amp; Variants</span>
                        </a>
                    </li>

                    <!-- SALES -->
                    <li class="nav-category">SALES</li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('orders', this)">
                            <i class="fa-solid fa-cart-shopping"></i>
                            <span>Orders</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('shipping', this)">
                            <i class="fa-solid fa-truck"></i>
                            <span>Shipping &amp; Delivery</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('returns', this)">
                            <i class="fa-solid fa-rotate-left"></i>
                            <span>Returns &amp; Refunds</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('customers', this)">
                            <i class="fa-solid fa-users"></i>
                            <span>Customers</span>
                        </a>
                    </li>

                    <!-- ENGAGEMENT & MARKETING -->
                    <li class="nav-category">ENGAGEMENT &amp; MARKETING</li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('reviews', this)">
                            <i class="fa-solid fa-star"></i>
                            <span>Reviews &amp; Ratings</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('discounts', this)">
                            <i class="fa-solid fa-ticket"></i>
                            <span>Discounts</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('contact', this)">
                            <i class="fa-solid fa-envelope"></i>
                            <span>Contact Submissions</span>
                            <asp:Label ID="lblContactBadge" runat="server" CssClass="nav-badge-orange" Text="2" />
                        </a>
                    </li>

                    <!-- BUSINESS & REPORTS -->
                    <li class="nav-category">BUSINESS &amp; REPORTS</li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('lowStock', this)">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span>Low Stock Alerts</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('reports', this)">
                            <i class="fa-solid fa-chart-line"></i>
                            <span>Sales Analytics</span>
                        </a>
                    </li>

                    <!-- WEBSITE & SETTINGS -->
                    <li class="nav-category">WEBSITE &amp; SETTINGS</li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('adminUsers', this)">
                            <i class="fa-solid fa-user-shield"></i>
                            <span>Admin Users &amp; Roles</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:void(0)" onclick="switchNav('settings', this)">
                            <i class="fa-solid fa-gear"></i>
                            <span>Store Settings</span>
                        </a>
                    </li>
                    <li>
                        <a href="index.aspx" target="_blank">
                            <i class="fa-solid fa-store"></i>
                            <span>View Store</span>
                        </a>
                    </li>
                </ul>

                <div class="sidebar-footer">
                    <a href="login.aspx">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </aside>

            <!-- ================= MAIN CONTAINER ================= -->
            <main class="admin-main">

                <!-- TOP BAR -->
                <header class="admin-header">
                    <div class="header-title-box">
                        <h1 id="topbarTitle">Dashboard</h1>
                        <p id="topbarSub">Monitor key metrics and recent activity.</p>
                    </div>
                    <div class="header-right">
                        <div class="header-bell" title="Notifications">
                            <i class="fa-solid fa-bell"></i>
                        </div>
                        <div class="header-welcome">Welcome back, Admin</div>
                    </div>
                </header>

                <div class="admin-content-area">

                    <!-- Server Alert Toast -->
                    <asp:Label ID="lblAdminProductMsg" runat="server" Visible="false" CssClass="admin-alert-banner" />

                    <!-- Hidden fields for quick server operations -->
                    <asp:HiddenField ID="hdnActiveView" runat="server" Value="dashboard" />

                    <asp:HiddenField ID="hdnQuickOrderId" runat="server" />
                    <asp:HiddenField ID="hdnQuickOrderStatus" runat="server" />
                    <asp:Button ID="btnQuickUpdateOrderStatus" runat="server" OnClick="btnQuickUpdateOrderStatus_Click" Style="display:none;" />

                    <asp:HiddenField ID="hdnStockProdId" runat="server" />
                    <asp:HiddenField ID="hdnStockSize" runat="server" />
                    <asp:HiddenField ID="hdnStockQty" runat="server" />
                    <asp:HiddenField ID="hdnStockOp" runat="server" />
                    <asp:Button ID="btnQuickAdjustSizeStock" runat="server" OnClick="btnQuickAdjustSizeStock_Click" Style="display:none;" />

                    <asp:HiddenField ID="hdnToggleProdId" runat="server" />
                    <asp:HiddenField ID="hdnToggleProdActive" runat="server" />
                    <asp:Button ID="btnQuickToggleActive" runat="server" OnClick="btnQuickToggleActive_Click" Style="display:none;" />

                    <asp:HiddenField ID="hdnQuickReturnId" runat="server" />
                    <asp:HiddenField ID="hdnQuickReturnOrderNum" runat="server" />
                    <asp:HiddenField ID="hdnQuickReturnStatus" runat="server" />
                    <asp:Button ID="btnQuickUpdateReturnStatus" runat="server" OnClick="btnQuickUpdateReturnStatus_Click" Style="display:none;" />

                    <!-- Legacy Hidden fields & Button -->
                    <asp:HiddenField ID="hdnEditProductId" runat="server" />
                    <asp:HiddenField ID="hdnAdjustStockId" runat="server" />
                    <asp:HiddenField ID="hdnAdjustStockValue" runat="server" />
                    <asp:Button ID="btnSaveStock" runat="server" OnClick="btnSaveStock_Click" Style="display:none;" />
                    <asp:HiddenField ID="hdnManageOrderNumber" runat="server" />
                    <asp:DropDownList ID="ddlManageOrderStatus" runat="server" Style="display:none;">
                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                        <asp:ListItem Value="Processing">Processing</asp:ListItem>
                        <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                        <asp:ListItem Value="Completed">Completed</asp:ListItem>
                        <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                    </asp:DropDownList>
                    <asp:DropDownList ID="ddlManagePaymentStatus" runat="server" Style="display:none;">
                        <asp:ListItem Value="Paid">Paid</asp:ListItem>
                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    </asp:DropDownList>
                    <asp:Button ID="btnUpdateOrderStatus" runat="server" OnClick="btnUpdateOrderStatus_Click" Style="display:none;" />

                    <!-- Legacy inputs to satisfy any designer references -->
                    <div style="display:none;">
                        <asp:TextBox ID="txtProductName" runat="server" />
                        <asp:DropDownList ID="ddlCategory" runat="server">
                            <asp:ListItem Value="Shirts">Shirts</asp:ListItem>
                        </asp:DropDownList>
                        <asp:TextBox ID="txtStock" runat="server" />
                        <asp:TextBox ID="txtPrice" runat="server" />
                        <asp:TextBox ID="txtOriginalPrice" runat="server" />
                        <asp:FileUpload ID="fileProductImages" runat="server" />
                        <asp:TextBox ID="txtImageUrl" runat="server" />
                        <asp:TextBox ID="txtDescription" runat="server" />
                        <asp:DropDownList ID="ddlProductStatus" runat="server" />
                        <asp:Button ID="btnAddProduct" runat="server" OnClick="btnAddProduct_Click" />
                        <asp:Label ID="lblTotalCustomers" runat="server" />
                        <asp:Label ID="lblProductCount" runat="server" />
                        <asp:Label ID="lblOrderCount" runat="server" />
                        <asp:Label ID="lblCustomerCount" runat="server" />
                        <asp:Label ID="lblReportOrders" runat="server" />
                        <asp:Label ID="lblReportCustomers" runat="server" />
                        <asp:Label ID="lblReportAvgOrder" runat="server" />
                        <asp:Repeater ID="rptDashboardProducts" runat="server" />
                        <asp:Repeater ID="rptDashboardReviews" runat="server" />
                        <asp:Repeater ID="rptAdminProducts" runat="server" />
                        <asp:Repeater ID="rptAdminInventory" runat="server" />
                        <asp:Repeater ID="rptAdminOrders" runat="server" />
                        <asp:Repeater ID="rptAdminCustomers" runat="server" />
                        <asp:Repeater ID="rptAdminCoupons" runat="server" />
                        <asp:Repeater ID="rptAdminReviews" runat="server" />
                        <asp:Repeater ID="rptAdminCategories" runat="server" />
                        <asp:GridView ID="gvProducts" runat="server" />
                        <asp:GridView ID="gvOrders" runat="server" />
                        <asp:GridView ID="gvMessages" runat="server" />
                    </div>

                    <!-- ================= VIEW 1: DASHBOARD (IMAGE 1) ================= -->
                    <section id="dashboardView" class="admin-view active">
                        <div class="view-page-title">
                            <i class="fa-solid fa-chart-line"></i> Dashboard Overview
                        </div>

                        <!-- 6 Stat Cards with Blue Rounded Squircles -->
                        <div class="stat-cards-six-grid">
                            <!-- 1. Total Orders -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num"><asp:Label ID="lblTotalOrders" runat="server" Text="25" /></div>
                                    <div class="stat-card-label">Total Orders</div>
                                </div>
                                <div class="stat-card-squircle">
                                    <i class="fa-solid fa-cart-shopping"></i>
                                </div>
                            </div>

                            <!-- 2. Total Revenue -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num">&#8377;<asp:Label ID="lblTotalSales" runat="server" Text="40,904" /></div>
                                    <div class="stat-card-label">Total Revenue</div>
                                </div>
                                <div class="stat-card-squircle currency">
                                    Rs
                                </div>
                            </div>

                            <!-- 3. Pending Orders -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num"><asp:Label ID="lblPendingOrders" runat="server" Text="4" /></div>
                                    <div class="stat-card-label">Pending Orders</div>
                                </div>
                                <div class="stat-card-squircle">
                                    <i class="fa-regular fa-clock"></i>
                                </div>
                            </div>

                            <!-- 4. Products -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num"><asp:Label ID="lblTotalProducts" runat="server" Text="16" /></div>
                                    <div class="stat-card-label">Products</div>
                                </div>
                                <div class="stat-card-squircle">
                                    <i class="fa-solid fa-tag"></i>
                                </div>
                            </div>

                            <!-- 5. Avg Rating -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num"><asp:Label ID="lblAvgRating" runat="server" Text="4.5" /></div>
                                    <div class="stat-card-label">Avg Rating</div>
                                </div>
                                <div class="stat-card-squircle">
                                    <i class="fa-solid fa-star"></i>
                                </div>
                            </div>

                            <!-- 6. Contact Messages -->
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num"><asp:Label ID="lblContactMessagesCount" runat="server" Text="2 / 2" /></div>
                                    <div class="stat-card-label">Contact Messages</div>
                                </div>
                                <div class="stat-card-squircle">
                                    <i class="fa-solid fa-envelope"></i>
                                </div>
                            </div>
                        </div>

                        <!-- Recent Orders White Card (Image 1) -->
                        <div class="white-box-card">
                            <div class="card-header-row">
                                <div class="card-header-title">
                                    <i class="fa-regular fa-clock"></i> Recent Orders
                                </div>
                                <button type="button" class="btn-view-all-pill" onclick="switchNav('orders', document.querySelectorAll('.sidebar-nav a')[6])">
                                    View All &rarr;
                                </button>
                            </div>

                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Order ID</th>
                                            <th>Customer</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptDashboardRecentOrders" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#<%# Eval("id") %></td>
                                                    <td class="table-cust-name"><%# Eval("customer_name") %></td>
                                                    <td class="table-price-bold">&#8377;<%# Eval("total_amount", "{0:N0}") %></td>
                                                    <td>
                                                        <span class='status-badge <%# Eval("order_status").ToString().ToLower() %>'><%# Eval("order_status") %></span>
                                                    </td>
                                                    <td>
                                                        <select class="table-action-select" onchange="quickUpdateOrder('<%# Eval("id") %>', this.value, 'dashboard')">
                                                            <option value="Pending" <%# Eval("order_status").ToString().Equals("Pending", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Pending</option>
                                                            <option value="Processing" <%# Eval("order_status").ToString().Equals("Processing", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Processing</option>
                                                            <option value="Shipped" <%# Eval("order_status").ToString().Equals("Shipped", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Shipped</option>
                                                            <option value="Completed" <%# Eval("order_status").ToString().Equals("Completed", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Completed</option>
                                                            <option value="Cancelled" <%# Eval("order_status").ToString().Equals("Cancelled", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Cancelled</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 2: ADD PRODUCT (IMAGE 2) ================= -->
                    <section id="addProductView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-circle-plus"></i> Add New Product
                        </div>

                        <div class="white-box-card">
                            <div id="addProductValError" class="validation-error-banner"></div>
                            <!-- Row 1: Name, Category, Price -->
                            <div class="form-grid-three">
                                <div class="form-group">
                                    <label>Product Name <span class="req">*</span></label>
                                    <asp:TextBox ID="txtAddProdName" runat="server" CssClass="form-control-input" placeholder="e.g. Linen Casual Shirt" />
                                </div>
                                <div class="form-group">
                                    <label>Category <span class="req">*</span></label>
                                    <asp:DropDownList ID="ddlAddProdCategory" runat="server" CssClass="form-control-input">
                                        <asp:ListItem Value="T-Shirts">T-Shirt</asp:ListItem>
                                        <asp:ListItem Value="Shirts">Shirt</asp:ListItem>
                                        <asp:ListItem Value="Pants">Pants</asp:ListItem>
                                        <asp:ListItem Value="Jeans">Jeans</asp:ListItem>
                                        <asp:ListItem Value="Shorts">Shorts</asp:ListItem>
                                        <asp:ListItem Value="Hoodies">Hoodie</asp:ListItem>
                                        <asp:ListItem Value="Jackets">Jacket</asp:ListItem>
                                        <asp:ListItem Value="Sweatshirts">Sweatshirt</asp:ListItem>
                                        <asp:ListItem Value="Trousers">Trousers</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <label>Price (&#8377;) <span class="req">*</span></label>
                                    <asp:TextBox ID="txtAddProdPrice" runat="server" CssClass="form-control-input" placeholder="999" />
                                </div>
                            </div>

                            <!-- Row 2: Sizes, Main Image, Additional Image 2 -->
                            <div class="form-grid-three">
                                <div class="form-group">
                                    <label>Sizes (comma separated) <span class="req">*</span></label>
                                    <asp:TextBox ID="txtAddProdSizes" runat="server" CssClass="form-control-input" Text="S, M, L, XL, XXL" />
                                </div>
                                <div class="form-group">
                                    <label>Main Image <span class="req">*</span></label>
                                    <asp:TextBox ID="txtAddProdImg1" runat="server" CssClass="form-control-input" placeholder="images/product_marble_tshirt.jpg" />
                                </div>
                                <div class="form-group">
                                    <label>Additional Image 2</label>
                                    <asp:TextBox ID="txtAddProdImg2" runat="server" CssClass="form-control-input" placeholder="Additional image URL" />
                                </div>
                            </div>

                            <!-- Row 3: Additional Images 3, 4, 5 -->
                            <div class="form-grid-three">
                                <div class="form-group">
                                    <label>Additional Image 3</label>
                                    <asp:TextBox ID="txtAddProdImg3" runat="server" CssClass="form-control-input" placeholder="Additional image URL" />
                                </div>
                                <div class="form-group">
                                    <label>Additional Image 4</label>
                                    <asp:TextBox ID="txtAddProdImg4" runat="server" CssClass="form-control-input" placeholder="Additional image URL" />
                                </div>
                                <div class="form-group">
                                    <label>Additional Image 5</label>
                                    <asp:TextBox ID="txtAddProdImg5" runat="server" CssClass="form-control-input" placeholder="Additional image URL" />
                                </div>
                            </div>

                            <!-- Row 4: Material, Care Instructions -->
                            <div class="form-grid-two">
                                <div class="form-group">
                                    <label>Material</label>
                                    <asp:TextBox ID="txtAddProdMaterial" runat="server" CssClass="form-control-input" Text="Cotton" />
                                </div>
                                <div class="form-group">
                                    <label>Care Instructions</label>
                                    <asp:TextBox ID="txtAddProdCare" runat="server" CssClass="form-control-input" Text="Machine wash" />
                                </div>
                            </div>

                            <!-- Row 5: Product Description -->
                            <div class="form-group" style="margin-bottom: 20px;">
                                <label>Product Description <span class="req">*</span></label>
                                <asp:TextBox ID="txtAddProdDesc" runat="server" TextMode="MultiLine" CssClass="form-control-input" placeholder="Enter detailed product description..." />
                            </div>

                            <!-- Row 6: Size-wise Stock Management Inputs -->
                            <div class="size-stock-input-box">
                                <h3>Size-wise Stock</h3>
                                <div class="size-stock-inputs-row">
                                    <div class="size-stock-col">
                                        <label>Size S</label>
                                        <asp:TextBox ID="txtAddStockS" runat="server" CssClass="form-control-input" Text="0" />
                                    </div>
                                    <div class="size-stock-col">
                                        <label>Size M</label>
                                        <asp:TextBox ID="txtAddStockM" runat="server" CssClass="form-control-input" Text="0" />
                                    </div>
                                    <div class="size-stock-col">
                                        <label>Size L</label>
                                        <asp:TextBox ID="txtAddStockL" runat="server" CssClass="form-control-input" Text="0" />
                                    </div>
                                    <div class="size-stock-col">
                                        <label>Size XL</label>
                                        <asp:TextBox ID="txtAddStockXL" runat="server" CssClass="form-control-input" Text="0" />
                                    </div>
                                    <div class="size-stock-col">
                                        <label>Size XXL</label>
                                        <asp:TextBox ID="txtAddStockXXL" runat="server" CssClass="form-control-input" Text="0" />
                                    </div>
                                </div>
                            </div>

                            <div>
                                <asp:Button ID="btnAddProductSubmit" runat="server" CssClass="btn-submit-green" Text="+ Add Product" OnClick="btnAddProductSubmit_Click" OnClientClick="return validateAddProductForm();" />
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 3: MANAGE PRODUCTS (IMAGE 3) ================= -->
                    <section id="manageProductsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-boxes-stacked"></i> Manage Products
                        </div>

                        <!-- 3-Column Product Cards Grid (Matching Image 3) -->
                        <div class="products-cards-grid">
                            <asp:Repeater ID="rptManageProductsGrid" runat="server">
                                <ItemTemplate>
                                    <div class="prod-card">
                                        <img src='<%# GetFirstImage(Eval("image_url")) %>' class="prod-card-thumb" alt="Product" onerror="this.src='https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=300'" />
                                        <div class="prod-card-body">
                                            <div class="prod-card-title"><%# Eval("name") %></div>
                                            <div class="prod-card-price">&#8377;<%# Eval("price", "{0:N0}") %></div>

                                            <div class="size-badges-row">
                                                <span class="size-badge-pill">S: <%# Eval("stock_s") %></span>
                                                <span class="size-badge-pill">M: <%# Eval("stock_m") %></span>
                                                <span class="size-badge-pill">L: <%# Eval("stock_l") %></span>
                                                <span class="size-badge-pill">XL: <%# Eval("stock_xl") %></span>
                                                <span class="size-badge-pill">XXL: <%# Eval("stock_xxl") %></span>
                                            </div>

                                            <div class="stock-total-badge">
                                                Total Stock: <%# Eval("stock") %>
                                            </div>

                                            <div class="prod-card-rating">
                                                &#9733;&#9733;&#9733;&#9733;&#9733; <span>(<%# Eval("review_count") %>)</span>
                                            </div>

                                            <div class="prod-card-actions">
                                                <button type="button" class="btn-card-details" onclick="openDetailsModal('<%# Eval("id") %>', '<%# CleanJs(Eval("name")) %>', '<%# CleanJs(Eval("category")) %>', '<%# Eval("price") %>', '<%# Eval("stock") %>', '<%# CleanJs(Eval("image_url")) %>', '<%# CleanJs(Eval("description")) %>')">Details</button>
                                                
                                                <select class="select-card-status" onchange="quickToggleProductActive('<%# Eval("id") %>', this.value)">
                                                    <option value="1" <%# Convert.ToInt32(Eval("is_active")) == 1 ? "selected" : "" %>>Active</option>
                                                    <option value="0" <%# Convert.ToInt32(Eval("is_active")) == 0 ? "selected" : "" %>>Inactive</option>
                                                </select>

                                                <asp:LinkButton ID="btnCardDelete" runat="server" CssClass="btn-card-delete" CommandArgument='<%# Eval("id") %>' OnClick="btnDeleteProduct_Click" OnClientClick="return confirm('Are you sure you want to delete this product?');">Delete</asp:LinkButton>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </section>

                    <!-- ================= VIEW 4: SIZE-WISE STOCK (IMAGE 4) ================= -->
                    <section id="sizeStockView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-warehouse"></i> Size-wise Stock Management
                        </div>

                        <!-- 3-Column Stock Cards Grid (Matching Image 4) -->
                        <div class="products-cards-grid">
                            <asp:Repeater ID="rptSizeStockGrid" runat="server">
                                <ItemTemplate>
                                    <div class="stock-manage-card">
                                        <div>
                                            <div class="stock-card-top">
                                                <div>
                                                    <div class="stock-card-title"><%# Eval("name") %></div>
                                                    <div class="stock-card-sub">&#8377;<%# Eval("price", "{0:N0}") %> | ID: <%# Eval("id") %></div>
                                                </div>
                                                <div class="stock-card-total-pill">Total: <%# Eval("stock") %></div>
                                            </div>

                                            <div class="stock-section-title">AVAILABLE SIZES &amp; STOCK</div>
                                            <div class="size-badges-row">
                                                <span class="size-badge-pill">S: <%# Eval("stock_s") %></span>
                                                <span class="size-badge-pill">M: <%# Eval("stock_m") %></span>
                                                <span class="size-badge-pill">L: <%# Eval("stock_l") %></span>
                                                <span class="size-badge-pill">XL: <%# Eval("stock_xl") %></span>
                                                <span class="size-badge-pill">XXL: <%# Eval("stock_xxl") %></span>
                                            </div>
                                        </div>

                                        <!-- Quick Adjust Controls (Matching Image 4) -->
                                        <div class="stock-adjust-form">
                                            <select class="stock-select-size" id='<%# "sel_size_" + Eval("id") %>'>
                                                <option value="S">Size S</option>
                                                <option value="M">Size M</option>
                                                <option value="L">Size L</option>
                                                <option value="XL">Size XL</option>
                                                <option value="XXL">Size XXL</option>
                                            </select>
                                            <input type="number" class="stock-input-qty" id='<%# "qty_" + Eval("id") %>' value="1" min="1" max="100" />
                                            <button type="button" class="btn-stock-add" onclick="quickStockAdjust('<%# Eval("id") %>', 'add')">+ Add</button>
                                            <button type="button" class="btn-stock-remove" onclick="quickStockAdjust('<%# Eval("id") %>', 'remove')">- Remove</button>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </section>

                    <!-- ================= VIEW 5: ALL ORDERS (IMAGE 5) ================= -->
                    <section id="ordersView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-cart-shopping"></i> All Orders (<asp:Label ID="lblAllOrdersCount" runat="server" Text="25" />)
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Total</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptOrdersTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#<%# Eval("id") %></td>
                                                    <td>
                                                        <div class="table-cust-name"><%# Eval("customer_name") %></div>
                                                        <div class="table-cust-sub"><%# Eval("user_email") %></div>
                                                    </td>
                                                    <td class="table-price-bold">&#8377;<%# Eval("total_amount", "{0:N0}") %></td>
                                                    <td>
                                                        <span class='status-badge <%# Eval("order_status").ToString().ToLower() %>'><%# Eval("order_status") %></span>
                                                    </td>
                                                    <td style="color:#64748b; font-size:12.5px;"><%# Eval("date_formatted") %></td>
                                                    <td>
                                                        <select class="table-action-select" onchange="quickUpdateOrder('<%# Eval("id") %>', this.value, 'orders')">
                                                            <option value="Pending" <%# Eval("order_status").ToString().Equals("Pending", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Pending</option>
                                                            <option value="Processing" <%# Eval("order_status").ToString().Equals("Processing", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Processing</option>
                                                            <option value="Shipped" <%# Eval("order_status").ToString().Equals("Shipped", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Shipped</option>
                                                            <option value="Completed" <%# Eval("order_status").ToString().Equals("Completed", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Completed</option>
                                                            <option value="Cancelled" <%# Eval("order_status").ToString().Equals("Cancelled", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Cancelled</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 6: CUSTOMERS ================= -->
                    <section id="customersView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-users"></i> Registered Customers
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Customer ID</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>City / Location</th>
                                            <th>Orders</th>
                                            <th>Joined Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptCustomersTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold"><%# Eval("user_id_display") %></td>
                                                    <td class="table-cust-name"><%# Eval("name") %></td>
                                                    <td><%# Eval("email") %></td>
                                                    <td><%# Eval("phone") %></td>
                                                    <td><%# Eval("city") %></td>
                                                    <td><strong style="color:var(--primary);"><%# Eval("order_count") %> Orders</strong></td>
                                                    <td style="color:#64748b;"><%# Eval("date_formatted") %></td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 7: REVIEWS & RATINGS ================= -->
                    <section id="reviewsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-star"></i> Reviews &amp; Customer Ratings
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Product</th>
                                            <th>Customer</th>
                                            <th>Rating</th>
                                            <th>Review Comment</th>
                                            <th>Status</th>
                                            <th>Date</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptReviewsTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-cust-name"><%# Eval("product_name") %></td>
                                                    <td><%# Eval("customer_name") %></td>
                                                    <td style="color:#f59e0b; font-weight:800;">&#9733; <%# Eval("rating", "{0:0.0}") %></td>
                                                    <td style="max-width:280px; font-size:12.5px; color:#475569;">"<%# Eval("comment") %>"</td>
                                                    <td><span class="status-badge completed"><%# Eval("status") %></span></td>
                                                    <td style="color:#64748b; font-size:12px;"><%# Eval("date_formatted") %></td>
                                                    <td>
                                                        <asp:LinkButton ID="btnDelRev" runat="server" CssClass="btn-card-delete" CommandArgument='<%# Eval("id") %>' OnClick="btnDeleteReview_Click" OnClientClick="return confirm('Delete this customer review?');">Delete</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 8: DISCOUNTS & COUPONS ================= -->
                    <section id="discountsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-ticket"></i> Discounts &amp; Coupons
                        </div>

                        <!-- Add Coupon Form -->
                        <div class="white-box-card">
                            <div id="couponValError" class="validation-error-banner"></div>
                            <div class="card-header-title" style="margin-bottom: 16px;">
                                <i class="fa-solid fa-plus-circle"></i> Create New Coupon
                            </div>
                            <div class="form-grid-three">
                                <div class="form-group">
                                    <label>Coupon Code <span class="req">*</span></label>
                                    <asp:TextBox ID="txtNewCouponCode" runat="server" CssClass="form-control-input" placeholder="e.g. TEXTILES20" />
                                </div>
                                <div class="form-group">
                                    <label>Discount Type</label>
                                    <asp:DropDownList ID="ddlNewCouponType" runat="server" CssClass="form-control-input">
                                        <asp:ListItem Value="Percentage">Percentage (%)</asp:ListItem>
                                        <asp:ListItem Value="Flat">Flat (₹)</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group">
                                    <label>Discount Value <span class="req">*</span></label>
                                    <asp:TextBox ID="txtNewCouponValue" runat="server" CssClass="form-control-input" placeholder="20" />
                                </div>
                            </div>
                            <div class="form-grid-three">
                                <div class="form-group">
                                    <label>Minimum Order (&#8377;)</label>
                                    <asp:TextBox ID="txtNewCouponMinOrder" runat="server" CssClass="form-control-input" Text="0" />
                                </div>
                                <div class="form-group">
                                    <label>Expiry Date <span class="req">*</span></label>
                                    <asp:TextBox ID="txtNewCouponExpiry" runat="server" TextMode="Date" CssClass="form-control-input" />
                                </div>
                                <div class="form-group">
                                    <label>Status</label>
                                    <asp:DropDownList ID="ddlNewCouponStatus" runat="server" CssClass="form-control-input">
                                        <asp:ListItem Value="Active">Active</asp:ListItem>
                                        <asp:ListItem Value="Inactive">Inactive</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:Button ID="btnSaveCoupon" runat="server" CssClass="btn-submit-green" Text="+ Add Coupon" OnClick="btnSaveCoupon_Click" OnClientClick="return validateCouponForm();" />
                        </div>

                        <!-- Coupons Table -->
                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Coupon Code</th>
                                            <th>Discount</th>
                                            <th>Min Order</th>
                                            <th>Expiry Date</th>
                                            <th>Status</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptCouponsTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold" style="color:var(--primary);"><%# Eval("code") %></td>
                                                    <td><strong><%# Eval("discount_display") %></strong></td>
                                                    <td>&#8377;<%# Eval("min_order", "{0:N0}") %></td>
                                                    <td style="color:#64748b;"><%# Eval("date_formatted") %></td>
                                                    <td><span class="status-badge completed"><%# Eval("status") %></span></td>
                                                    <td>
                                                        <asp:LinkButton ID="btnDelCpn" runat="server" CssClass="btn-card-delete" CommandArgument='<%# Eval("id") %>' OnClick="btnDeleteCoupon_Click" OnClientClick="return confirm('Delete this coupon?');">Delete</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 9: CONTACT SUBMISSIONS ================= -->
                    <section id="contactView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-envelope"></i> Contact Submissions &amp; Inquiries
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Sender Name</th>
                                            <th>Email</th>
                                            <th>Subject</th>
                                            <th>Message</th>
                                            <th>Date Received</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptContactTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#<%# Eval("id") %></td>
                                                    <td class="table-cust-name"><%# Eval("name") %></td>
                                                    <td><a href='<%# "mailto:" + Eval("email") %>' style="color:var(--primary); text-decoration:none;"><%# Eval("email") %></a></td>
                                                    <td><strong><%# Eval("subject") %></strong></td>
                                                    <td style="max-width:300px; font-size:12.5px; color:#475569;"><%# Eval("message") %></td>
                                                    <td style="color:#64748b; font-size:12px;"><%# Eval("date_formatted") %></td>
                                                    <td>
                                                        <asp:LinkButton ID="btnDelMsg" runat="server" CssClass="btn-card-delete" CommandArgument='<%# Eval("id") %>' OnClick="btnDeleteMessage_Click" OnClientClick="return confirm('Delete this contact message?');">Delete</asp:LinkButton>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 10: CATEGORIES & COLLECTIONS ================= -->
                    <section id="categoriesView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-layer-group"></i> Categories &amp; Collections
                        </div>

                        <div class="products-cards-grid">
                            <asp:Repeater ID="rptCategoriesGrid" runat="server">
                                <ItemTemplate>
                                    <div class="white-box-card" style="margin-bottom:0;">
                                        <div style="font-size:18px; font-weight:800; color:var(--text-main); margin-bottom:6px;"><%# Eval("category") %></div>
                                        <div style="color:var(--text-muted); font-size:13px; margin-bottom:12px;"><%# Eval("prod_count") %> Products Live</div>
                                        <div class="stock-total-badge">Total Stock: <%# Eval("total_stock") %> units</div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </section>

                    <!-- ================= VIEW 11: COLORS & VARIANTS ================= -->
                    <section id="colorsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-palette"></i> Colors &amp; Garment Variants
                        </div>

                        <div class="products-cards-grid">
                            <asp:Repeater ID="rptColorsGrid" runat="server">
                                <ItemTemplate>
                                    <div class="white-box-card" style="display:flex; align-items:center; gap:16px; margin-bottom:0;">
                                        <div style='<%# "width:48px; height:48px; border-radius:12px; border:2px solid #e2e8f0; background-color:" + Eval("hex_code") %>'></div>
                                        <div>
                                            <div style="font-size:16px; font-weight:800;"><%# Eval("color_name") %></div>
                                            <div style="font-size:12px; color:#64748b;"><%# Eval("product_count") %> Items in Catalog</div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </section>

                    <!-- ================= VIEW 12: SHIPPING & DELIVERY ================= -->
                    <section id="shippingView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-truck"></i> Shipping &amp; Logistics
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Order #</th>
                                            <th>Recipient</th>
                                            <th>Courier Partner</th>
                                            <th>Destination</th>
                                            <th>Status</th>
                                            <th>Estimated Delivery</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptShippingTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#<%# Eval("id") %></td>
                                                    <td class="table-cust-name"><%# Eval("customer_name") %></td>
                                                    <td><i class="fa-solid fa-box" style="color:var(--primary);"></i> BlueDart Express</td>
                                                    <td><%# Eval("city") %></td>
                                                    <td><span class='status-badge <%# Eval("order_status").ToString().ToLower() %>'><%# Eval("order_status") %></span></td>
                                                    <td style="color:#64748b; font-size:12.5px;">2-4 Business Days</td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 13: RETURNS & REFUNDS ================= -->
                    <section id="returnsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-rotate-left"></i> Returns &amp; Exchange Requests
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Return ID</th>
                                            <th>Order #</th>
                                            <th>Customer</th>
                                            <th>Garments &amp; Return Reason</th>
                                            <th>Refund Amount</th>
                                            <th>Requested Date</th>
                                            <th>Current Status</th>
                                            <th>Process Request</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptAdminReturnsTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#RET-<%# Eval("id") %></td>
                                                    <td>
                                                        <strong style="color:var(--primary);">#<%# Eval("order_number") %></strong>
                                                    </td>
                                                    <td>
                                                        <div class="table-cust-name"><%# Eval("customer_name") %></div>
                                                        <div class="table-cust-sub"><%# Eval("user_email") %></div>
                                                    </td>
                                                    <td style="max-width: 250px;">
                                                        <div style="font-weight: 700; color: #1e293b; font-size: 13px;"><%# Eval("product_names") %></div>
                                                        <div style="font-size: 12px; color: #be185d; font-weight: 600; margin-top: 2px;"><i class="fa-solid fa-tag"></i> Reason: <%# Eval("reason") %></div>
                                                        <div style="font-size: 11.5px; color: #64748b; font-style: italic; margin-top: 2px;"><%# Eval("comments") %></div>
                                                    </td>
                                                    <td class="table-price-bold" style="color: #be185d;">
                                                        &#8377;<%# Eval("refund_amount", "{0:N0}") %>
                                                    </td>
                                                    <td style="color:#64748b; font-size:12.5px;">
                                                        <%# Convert.ToDateTime(Eval("requested_at")).ToString("dd MMM yyyy, hh:mm tt") %>
                                                    </td>
                                                    <td>
                                                        <span class='badge-return return-<%# Eval("return_status").ToString().ToLower() %>'>
                                                            <%# Eval("return_status") %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <select class="table-action-select" onchange="quickUpdateReturnStatus('<%# Eval("id") %>', '<%# Eval("order_number") %>', this.value)">
                                                            <option value="Pending" <%# Eval("return_status").ToString().Equals("Pending", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Pending</option>
                                                            <option value="Approved" <%# Eval("return_status").ToString().Equals("Approved", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Approved</option>
                                                            <option value="Rejected" <%# Eval("return_status").ToString().Equals("Rejected", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Rejected</option>
                                                            <option value="Completed" <%# Eval("return_status").ToString().Equals("Completed", StringComparison.OrdinalIgnoreCase) ? "selected" : "" %>>Completed (Refunded)</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 14: LOW STOCK ALERTS ================= -->
                    <section id="lowStockView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-triangle-exclamation"></i> Low Stock Alerts
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Product Name</th>
                                            <th>Category</th>
                                            <th>S</th>
                                            <th>M</th>
                                            <th>L</th>
                                            <th>XL</th>
                                            <th>XXL</th>
                                            <th>Total Stock</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptLowStockList" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-cust-name"><%# Eval("name") %></td>
                                                    <td><%# Eval("category") %></td>
                                                    <td><span class="size-badge-pill"><%# Eval("stock_s") %></span></td>
                                                    <td><span class="size-badge-pill"><%# Eval("stock_m") %></span></td>
                                                    <td><span class="size-badge-pill"><%# Eval("stock_l") %></span></td>
                                                    <td><span class="size-badge-pill"><%# Eval("stock_xl") %></span></td>
                                                    <td><span class="size-badge-pill"><%# Eval("stock_xxl") %></span></td>
                                                    <td>
                                                        <strong style='<%# Convert.ToInt32(Eval("stock")) <= 5 ? "color:#dc2626;" : "color:#d97706;" %>'>
                                                            <%# Eval("stock") %> units
                                                        </strong>
                                                    </td>
                                                    <td>
                                                        <button type="button" class="btn-card-details" onclick="switchNav('sizeStock', document.querySelectorAll('.sidebar-nav a')[4])">Restock Size</button>
                                                    </td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 15: SALES ANALYTICS ================= -->
                    <section id="reportsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-chart-line"></i> Sales Analytics &amp; Reports
                        </div>

                        <div class="stat-cards-six-grid">
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num">&#8377;<asp:Label ID="lblReportSales" runat="server" Text="40,904" /></div>
                                    <div class="stat-card-label">Total Revenue</div>
                                </div>
                                <div class="stat-card-squircle currency">Rs</div>
                            </div>
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num">25</div>
                                    <div class="stat-card-label">Completed Orders</div>
                                </div>
                                <div class="stat-card-squircle"><i class="fa-solid fa-cart-shopping"></i></div>
                            </div>
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num">&#8377;1,636</div>
                                    <div class="stat-card-label">Avg Order Value</div>
                                </div>
                                <div class="stat-card-squircle currency">AOV</div>
                            </div>
                            <div class="stat-card-clean">
                                <div>
                                    <div class="stat-card-num">94.2%</div>
                                    <div class="stat-card-label">Order Fulfillment Rate</div>
                                </div>
                                <div class="stat-card-squircle"><i class="fa-solid fa-check-double"></i></div>
                            </div>
                        </div>

                        <div class="white-box-card" style="margin-top: 20px;">
                            <h3 style="font-size: 15px; font-weight: 700; color: #1e293b; margin: 0 0 15px; display: flex; align-items: center; gap: 8px;">
                                <i class="fa-solid fa-money-bill-wave" style="color: #10b981;"></i> Payment &amp; Channel Breakdown
                            </h3>
                            <div style="background: #f0fdf4; border: 1px solid #bbf7d0; border-radius: 10px; padding: 18px 22px; display: flex; align-items: center; justify-content: space-between;">
                                <div>
                                    <div style="font-size: 16px; font-weight: 800; color: #166534; display: flex; align-items: center; gap: 8px;">
                                        <i class="fa-solid fa-hand-holding-dollar"></i> Cash on Delivery (COD) Only
                                    </div>
                                    <div style="font-size: 13px; color: #15803d; margin-top: 4px;">
                                        100% of all store transactions are processed securely via Cash on Delivery upon shipment arrival.
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 22px; font-weight: 800; color: #166534;">
                                        &#8377;<asp:Label ID="lblReportCodSales" runat="server" Text="40,904" />
                                    </div>
                                    <div style="font-size: 12px; font-weight: 700; color: #15803d; text-transform: uppercase;">
                                        100% COD Share
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 16: ADMIN USERS & ROLES ================= -->
                    <section id="adminUsersView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-user-shield"></i> Admin Users &amp; Roles
                        </div>

                        <div class="white-box-card">
                            <div class="clean-table-responsive">
                                <table class="clean-table">
                                    <thead>
                                        <tr>
                                            <th>Admin ID</th>
                                            <th>Username</th>
                                            <th>Email</th>
                                            <th>Assigned Role</th>
                                            <th>Permissions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <asp:Repeater ID="rptAdminUsersTable" runat="server">
                                            <ItemTemplate>
                                                <tr>
                                                    <td class="table-id-bold">#ADM-<%# Eval("id") %></td>
                                                    <td class="table-cust-name"><%# Eval("username") %></td>
                                                    <td><%# Eval("email") %></td>
                                                    <td><span class="status-badge processing"><%# Eval("role") %></span></td>
                                                    <td style="color:#64748b; font-size:12.5px;">Full Store &amp; Database Access</td>
                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </section>

                    <!-- ================= VIEW 17: STORE SETTINGS ================= -->
                    <section id="settingsView" class="admin-view">
                        <div class="view-page-title">
                            <i class="fa-solid fa-gear"></i> Store Settings &amp; Configuration
                        </div>

                        <div class="white-box-card">
                            <div class="form-grid-two">
                                <div class="form-group">
                                    <label>Store Name</label>
                                    <input type="text" class="form-control-input" value="TEXTILES Men's Clothing" readonly />
                                </div>
                                <div class="form-group">
                                    <label>Currency</label>
                                    <input type="text" class="form-control-input" value="INR (&#8377; - Indian Rupee)" readonly />
                                </div>
                            </div>
                            <div class="form-grid-two">
                                <div class="form-group">
                                    <label>Support Email</label>
                                    <input type="text" class="form-control-input" value="support@textiles.com" readonly />
                                </div>
                                <div class="form-group">
                                    <label>Support Phone</label>
                                    <input type="text" class="form-control-input" value="+91 98251 44520" readonly />
                                </div>
                            </div>
                            <div class="form-grid-two">
                                <div class="form-group">
                                    <label>Shipping Fee Policy</label>
                                    <input type="text" class="form-control-input" value="Free Shipping on all orders above &#8377;999" readonly />
                                </div>
                                <div class="form-group">
                                    <label>Inventory Low Stock Threshold</label>
                                    <input type="text" class="form-control-input" value="Under 5 units per size" readonly />
                                </div>
                            </div>
                        </div>
                    </section>

                </div>
            </main>
        </div>

        <!-- Quick Details Modal -->
        <div id="detailsModal" class="modal-overlay">
            <div class="modal-box">
                <div class="modal-header">
                    <h3 id="dtlTitle" style="font-size:16px; font-weight:800;">Product Details</h3>
                    <button type="button" class="modal-close" onclick="closeDetailsModal()">&times;</button>
                </div>
                <div style="display:flex; gap:16px; margin-bottom:14px;">
                    <img id="dtlImg" src="" style="width:110px; height:110px; object-fit:cover; border-radius:10px;" alt="product" />
                    <div>
                        <div id="dtlName" style="font-size:15px; font-weight:800; margin-bottom:4px;"></div>
                        <div id="dtlCategory" style="font-size:12.5px; color:#64748b; margin-bottom:6px;"></div>
                        <div id="dtlPrice" style="font-size:17px; font-weight:800; color:var(--primary);"></div>
                    </div>
                </div>
                <p id="dtlDesc" style="font-size:13px; color:#475569; line-height:1.5; margin-bottom:16px;"></p>
                <div style="text-align:right;">
                    <button type="button" class="btn-card-details" onclick="closeDetailsModal()">Close</button>
                </div>
            </div>
        </div>

    </form>

    <script>
        // ================= NAVIGATION VIEW SWITCHER =================
        var currentActiveView = 'dashboard';

        var viewTitles = {
            'dashboard': { title: 'Dashboard', sub: 'Monitor key metrics and recent activity.' },
            'addProduct': { title: 'Add Product', sub: 'Create new products with sizes, images, and stock.' },
            'manageProducts': { title: 'Manage Products', sub: 'Update product status, review stars, and moderate catalog.' },
            'categories': { title: 'Categories & Collections', sub: 'Manage garment product lines and classifications.' },
            'sizeStock': { title: 'Size-wise Stock', sub: 'View and update product stock by size in one place.' },
            'colors': { title: 'Colors & Variants', sub: 'Manage fabric colorways and garment finishes.' },
            'orders': { title: 'Orders', sub: 'Track orders and update their current fulfillment status.' },
            'shipping': { title: 'Shipping & Delivery', sub: 'Monitor shipments, dispatch status, and couriers.' },
            'returns': { title: 'Returns & Refunds', sub: 'Process customer returns and exchange requests.' },
            'customers': { title: 'Customers', sub: 'View registered store shoppers and purchasing history.' },
            'reviews': { title: 'Reviews & Ratings', sub: 'Moderate customer feedback and star ratings.' },
            'discounts': { title: 'Discounts & Coupons', sub: 'Create promotional vouchers, sales, and cart discounts.' },
            'contact': { title: 'Contact Submissions', sub: 'Manage inquiries submitted through website contact form.' },
            'lowStock': { title: 'Low Stock Alerts', sub: 'Real-time alert for garments running out of inventory.' },
            'reports': { title: 'Sales Analytics', sub: 'Revenue insights, average order values, and sales charts.' },
            'adminUsers': { title: 'Admin Users & Roles', sub: 'Configure team member accounts and administrative permissions.' },
            'settings': { title: 'Store Settings', sub: 'Configure shop preferences, policies, and contact information.' }
        };

        function switchNav(viewName, clickedElement) {
            currentActiveView = viewName;
            var hdn = document.getElementById('<%= hdnActiveView.ClientID %>');
            if (hdn) hdn.value = viewName;

            // Remove active from all sidebar links
            document.querySelectorAll('.sidebar-nav a').forEach(function (a) {
                a.classList.remove('active');
            });

            // If clickedElement provided, add active; otherwise find link by viewName
            if (clickedElement) {
                clickedElement.classList.add('active');
            } else {
                var links = document.querySelectorAll('.sidebar-nav a');
                for (var i = 0; i < links.length; i++) {
                    var oc = links[i].getAttribute('onclick') || '';
                    if (oc.indexOf("'" + viewName + "'") > -1) {
                        links[i].classList.add('active');
                        break;
                    }
                }
            }

            // Hide all views, show targeted view
            document.querySelectorAll('.admin-view').forEach(function (view) {
                view.classList.remove('active');
            });

            var target = document.getElementById(viewName + 'View');
            if (target) {
                target.classList.add('active');
            }

            // Update Topbar
            var topTitle = document.getElementById('topbarTitle');
            var topSub = document.getElementById('topbarSub');
            if (viewTitles[viewName]) {
                if (topTitle) topTitle.innerText = viewTitles[viewName].title;
                if (topSub) topSub.innerText = viewTitles[viewName].sub;
            }

            // Scroll to top of content
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        // ================= FAST ACTIONS =================
        function quickUpdateOrder(orderId, newStatus, returnView) {
            document.getElementById('<%= hdnQuickOrderId.ClientID %>').value = orderId;
            document.getElementById('<%= hdnQuickOrderStatus.ClientID %>').value = newStatus;
            document.getElementById('<%= hdnActiveView.ClientID %>').value = returnView || 'orders';
            document.getElementById('<%= btnQuickUpdateOrderStatus.ClientID %>').click();
        }

        function quickUpdateReturnStatus(returnId, orderNum, newStatus) {
            document.getElementById('<%= hdnQuickReturnId.ClientID %>').value = returnId;
            document.getElementById('<%= hdnQuickReturnOrderNum.ClientID %>').value = orderNum;
            document.getElementById('<%= hdnQuickReturnStatus.ClientID %>').value = newStatus;
            document.getElementById('<%= hdnActiveView.ClientID %>').value = 'returns';
            document.getElementById('<%= btnQuickUpdateReturnStatus.ClientID %>').click();
        }

        function quickStockAdjust(prodId, operation) {
            var sel = document.getElementById('sel_size_' + prodId);
            var inQty = document.getElementById('qty_' + prodId);
            if (!sel || !inQty) return;

            var size = sel.value;
            var qty = parseInt(inQty.value, 10);
            if (isNaN(qty) || qty <= 0) qty = 1;

            document.getElementById('<%= hdnStockProdId.ClientID %>').value = prodId;
            document.getElementById('<%= hdnStockSize.ClientID %>').value = size;
            document.getElementById('<%= hdnStockQty.ClientID %>').value = qty;
            document.getElementById('<%= hdnStockOp.ClientID %>').value = operation;
            document.getElementById('<%= hdnActiveView.ClientID %>').value = 'sizeStock';
            document.getElementById('<%= btnQuickAdjustSizeStock.ClientID %>').click();
        }

        function quickToggleProductActive(prodId, activeVal) {
            document.getElementById('<%= hdnToggleProdId.ClientID %>').value = prodId;
            document.getElementById('<%= hdnToggleProdActive.ClientID %>').value = activeVal;
            document.getElementById('<%= hdnActiveView.ClientID %>').value = 'manageProducts';
            document.getElementById('<%= btnQuickToggleActive.ClientID %>').click();
        }

        function openDetailsModal(id, name, cat, price, stock, img, desc) {
            document.getElementById('dtlName').innerText = name;
            document.getElementById('dtlCategory').innerText = cat;
            document.getElementById('dtlPrice').innerHTML = '&#8377;' + price;
            document.getElementById('dtlDesc').innerText = desc || 'Premium men\'s apparel crafted with durable styling and comfortable fit.';
            var firstImg = (img || '').split(',')[0].trim() || 'images/product_marble_tshirt.jpg';
            document.getElementById('dtlImg').src = firstImg;
            document.getElementById('detailsModal').classList.add('open');
        }

        function closeDetailsModal() {
            document.getElementById('detailsModal').classList.remove('open');
        }

        // ================= CLIENT FORM VALIDATION =================
        function validateAddProductForm() {
            var valid = true;
            var firstInvalid = null;
            var banner = document.getElementById('addProductValError');
            var errors = [];

            // Reset previous error classes
            var inputs = document.querySelectorAll('#addProductView .form-control-input');
            for (var i = 0; i < inputs.length; i++) {
                inputs[i].classList.remove('input-error');
            }

            var nameInput = document.getElementById('<%= txtAddProdName.ClientID %>');
            if (!nameInput || !nameInput.value.trim()) {
                if (nameInput) nameInput.classList.add('input-error');
                errors.push("Product Name is required.");
                valid = false;
                if (!firstInvalid) firstInvalid = nameInput;
            }

            var priceInput = document.getElementById('<%= txtAddProdPrice.ClientID %>');
            if (!priceInput || !priceInput.value.trim() || isNaN(priceInput.value) || parseFloat(priceInput.value) <= 0) {
                if (priceInput) priceInput.classList.add('input-error');
                errors.push("Price is required and must be greater than ₹0.");
                valid = false;
                if (!firstInvalid) firstInvalid = priceInput;
            }

            var sizesInput = document.getElementById('<%= txtAddProdSizes.ClientID %>');
            if (!sizesInput || !sizesInput.value.trim()) {
                if (sizesInput) sizesInput.classList.add('input-error');
                errors.push("Sizes are required (e.g., S, M, L, XL, XXL).");
                valid = false;
                if (!firstInvalid) firstInvalid = sizesInput;
            }

            var imgInput = document.getElementById('<%= txtAddProdImg1.ClientID %>');
            if (!imgInput || !imgInput.value.trim()) {
                if (imgInput) imgInput.classList.add('input-error');
                errors.push("Main Image URL is required.");
                valid = false;
                if (!firstInvalid) firstInvalid = imgInput;
            }

            var matInput = document.getElementById('<%= txtAddProdMaterial.ClientID %>');
            if (!matInput || !matInput.value.trim()) {
                if (matInput) matInput.classList.add('input-error');
                errors.push("Material is required (e.g., 100% Cotton).");
                valid = false;
                if (!firstInvalid) firstInvalid = matInput;
            }

            var careInput = document.getElementById('<%= txtAddProdCare.ClientID %>');
            if (!careInput || !careInput.value.trim()) {
                if (careInput) careInput.classList.add('input-error');
                errors.push("Care Instructions are required (e.g., Machine wash).");
                valid = false;
                if (!firstInvalid) firstInvalid = careInput;
            }

            var descInput = document.getElementById('<%= txtAddProdDesc.ClientID %>');
            if (!descInput || !descInput.value.trim()) {
                if (descInput) descInput.classList.add('input-error');
                errors.push("Product Description is required.");
                valid = false;
                if (!firstInvalid) firstInvalid = descInput;
            }

            // Size stocks
            var stockFields = [
                { id: '<%= txtAddStockS.ClientID %>', name: 'Size S' },
                { id: '<%= txtAddStockM.ClientID %>', name: 'Size M' },
                { id: '<%= txtAddStockL.ClientID %>', name: 'Size L' },
                { id: '<%= txtAddStockXL.ClientID %>', name: 'Size XL' },
                { id: '<%= txtAddStockXXL.ClientID %>', name: 'Size XXL' }
            ];

            var totalStock = 0;
            for (var j = 0; j < stockFields.length; j++) {
                var sf = stockFields[j];
                var elem = document.getElementById(sf.id);
                if (!elem || elem.value.trim() === '' || isNaN(elem.value) || parseInt(elem.value, 10) < 0) {
                    if (elem) elem.classList.add('input-error');
                    errors.push(sf.name + " stock must be a non-negative number (0 or more).");
                    valid = false;
                    if (!firstInvalid) firstInvalid = elem;
                } else {
                    totalStock += parseInt(elem.value, 10);
                }
            }

            // Size stock quantities must be non-negative (0 or higher)
            // A newly added product can start with 0 stock across all sizes

            if (!valid) {
                if (banner) {
                    banner.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> <div><strong>Please enter required product details:</strong><br/>' + errors.join('<br/>') + '</div>';
                    banner.style.display = 'flex';
                }
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
                return false;
            } else {
                if (banner) banner.style.display = 'none';
                return true;
            }
        }

        function validateCouponForm() {
            var valid = true;
            var firstInvalid = null;
            var banner = document.getElementById('couponValError');
            var errors = [];

            var codeInp = document.getElementById('<%= txtNewCouponCode.ClientID %>');
            var valInp = document.getElementById('<%= txtNewCouponValue.ClientID %>');
            var minInp = document.getElementById('<%= txtNewCouponMinOrder.ClientID %>');
            var expInp = document.getElementById('<%= txtNewCouponExpiry.ClientID %>');

            var couponInputs = [codeInp, valInp, minInp, expInp];
            for (var k = 0; k < couponInputs.length; k++) {
                if (couponInputs[k]) couponInputs[k].classList.remove('input-error');
            }

            if (!codeInp || !codeInp.value.trim()) {
                if (codeInp) codeInp.classList.add('input-error');
                errors.push("Coupon Code is required.");
                valid = false;
                if (!firstInvalid) firstInvalid = codeInp;
            }

            if (!valInp || !valInp.value.trim() || isNaN(valInp.value) || parseFloat(valInp.value) <= 0) {
                if (valInp) valInp.classList.add('input-error');
                errors.push("Discount Value is required and must be greater than 0.");
                valid = false;
                if (!firstInvalid) firstInvalid = valInp;
            }

            if (!minInp || minInp.value.trim() === '' || isNaN(minInp.value) || parseFloat(minInp.value) < 0) {
                if (minInp) minInp.classList.add('input-error');
                errors.push("Minimum Order must be a valid number (0 or more).");
                valid = false;
                if (!firstInvalid) firstInvalid = minInp;
            }

            if (!expInp || !expInp.value.trim()) {
                if (expInp) expInp.classList.add('input-error');
                errors.push("Expiry Date is required.");
                valid = false;
                if (!firstInvalid) firstInvalid = expInp;
            }

            if (!valid) {
                if (banner) {
                    banner.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> <div><strong>Please complete coupon details:</strong><br/>' + errors.join('<br/>') + '</div>';
                    banner.style.display = 'flex';
                }
                if (firstInvalid) {
                    firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    firstInvalid.focus();
                }
                return false;
            } else {
                if (banner) banner.style.display = 'none';
                return true;
            }
        }

        // Initialize active view on page load
        window.addEventListener('DOMContentLoaded', function () {
            var urlParams = new URLSearchParams(window.location.search);
            var queryTab = urlParams.get('tab');
            var hash = window.location.hash ? window.location.hash.replace('#', '') : '';
            var hdn = document.getElementById('<%= hdnActiveView.ClientID %>');
            var target = queryTab || hash || (hdn && hdn.value) || 'dashboard';
            switchNav(target);
        });
    </script>
</body>
</html>