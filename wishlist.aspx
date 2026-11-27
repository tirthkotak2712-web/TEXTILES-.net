<%@ Page Title="My Wishlist"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="wishlist.aspx.cs"
    Inherits="textiles.wishlist" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .wishlist-page {
            max-width: 1200px;
            margin: 0 auto;
            padding: 35px 20px 70px;
        }

        .wishlist-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
            flex-wrap: wrap;
            gap: 15px;
        }

        .wishlist-header h1 {
            font-size: 28px;
            font-weight: 800;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .wishlist-header h1 i {
            color: #e11d48;
        }

        .wishlist-count-badge {
            background: #ffe4e6;
            color: #e11d48;
            font-size: 14px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
        }

        .alert-banner {
            padding: 12px 18px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-success {
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
        }

        .alert-info {
            background: #e0f2fe;
            color: #0369a1;
            border: 1px solid #bae6fd;
        }

        /* Wishlist Grid */
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 24px;
        }

        .wishlist-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: all 0.25s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.04);
            position: relative;
        }

        .wishlist-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            border-color: #cbd5e1;
        }

        .wishlist-img-wrap {
            position: relative;
            height: 240px;
            background: #f8fafc;
            overflow: hidden;
        }

        .wishlist-img-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s;
        }

        .wishlist-card:hover .wishlist-img-wrap img {
            transform: scale(1.05);
        }

        .btn-remove-wishlist {
            position: absolute;
            top: 12px;
            right: 12px;
            width: 34px;
            height: 34px;
            background: rgba(255, 255, 255, 0.92);
            color: #ef4444;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-remove-wishlist:hover {
            background: #ef4444;
            color: #ffffff;
            transform: scale(1.1);
        }

        .wishlist-body {
            padding: 18px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .wishlist-title {
            font-size: 16px;
            font-weight: 700;
            color: #1e293b;
            margin-bottom: 8px;
            line-height: 1.35;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .wishlist-price {
            font-size: 18px;
            font-weight: 800;
            color: #1967d2;
            margin-bottom: 16px;
        }

        .wishlist-actions {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .btn-move-cart {
            background: #1967d2;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            padding: 10px 14px;
            font-size: 13.5px;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.2s;
            cursor: pointer;
        }

        .btn-move-cart:hover {
            background: #1557b0;
            color: #ffffff;
        }

        .btn-view-prod {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            padding: 8px 14px;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            transition: all 0.2s;
        }

        .btn-view-prod:hover {
            background: #e2e8f0;
            color: #0f172a;
        }

        /* Wishlist Size Selector */
        .wishlist-size-box {
            margin-bottom: 14px;
            background: #f8fafc;
            padding: 9px 12px;
            border-radius: 8px;
            border: 1px solid #e2e8f0;
        }

        .size-box-title {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 11.5px;
            font-weight: 700;
            color: #64748b;
            margin-bottom: 7px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }

        .size-box-title i {
            color: #1967d2;
        }

        .size-selector-row {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .btn-wishlist-size {
            min-width: 34px;
            height: 30px;
            padding: 0 8px;
            border: 1.5px solid #cbd5e1;
            background: #ffffff;
            color: #334155;
            font-size: 12px;
            font-weight: 700;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-wishlist-size:hover {
            border-color: #1967d2;
            color: #1967d2;
            transform: translateY(-1px);
        }

        .btn-wishlist-size.active {
            background: #1967d2;
            border-color: #1967d2;
            color: #ffffff;
            box-shadow: 0 2px 6px rgba(25, 103, 210, 0.35);
        }

        /* Empty State */
        .empty-wishlist-box {
            text-align: center;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 60px 20px;
            max-width: 550px;
            margin: 40px auto;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.04);
        }

        .empty-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: #ffe4e6;
            color: #e11d48;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
        }

        .empty-wishlist-box h2 {
            font-size: 24px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 10px;
        }

        .empty-wishlist-box p {
            color: #64748b;
            font-size: 15px;
            margin-bottom: 25px;
            line-height: 1.5;
        }

        .btn-shop-now {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #1967d2;
            color: #ffffff;
            padding: 12px 28px;
            border-radius: 8px;
            font-weight: 700;
            text-decoration: none;
            transition: background 0.2s;
        }

        .btn-shop-now:hover {
            background: #1557b0;
            color: #ffffff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="wishlist-page">
        <div class="wishlist-header">
            <h1>
                <i class="fa-solid fa-heart"></i> My Wishlist
                <span class="wishlist-count-badge"><%= TotalWishlistItems %> items</span>
            </h1>
            <div>
                <a href="product.aspx" class="btn-shop-now" style="padding: 9px 18px; font-size: 13.5px;">
                    <i class="fa-solid fa-bag-shopping"></i> Continue Shopping
                </a>
            </div>
        </div>

        <asp:Label ID="lblWishlistMsg" runat="server" Visible="false" CssClass="alert-banner alert-success" />

        <% if (TotalWishlistItems == 0) { %>
            <div class="empty-wishlist-box">
                <div class="empty-icon">
                    <i class="fa-regular fa-heart"></i>
                </div>
                <h2>Your Wishlist is Empty</h2>
                <p>You haven't saved any items yet. Browse our exclusive men's clothing catalog and click the heart icon on items you love!</p>
                <a href="product.aspx" class="btn-shop-now">
                    <i class="fa-solid fa-shirt"></i> Explore Men's Collection
                </a>
            </div>
        <% } else { %>
            <div class="wishlist-grid">
                <asp:Repeater ID="rptWishlist" runat="server">
                    <ItemTemplate>
                        <div class="wishlist-card">
                            <div class="wishlist-img-wrap">
                                <a href='<%# "wishlist.aspx?action=remove&id=" + Eval("product_id") %>' class="btn-remove-wishlist" title="Remove from wishlist">
                                    <i class="fa-solid fa-trash-can"></i>
                                </a>
                                <img src='<%# GetFirstImage(Eval("image_url")) %>' alt='<%# Eval("product_name") %>' onerror="this.src='images/product_marble_tshirt.jpg'" />
                            </div>
                            <div class="wishlist-body">
                                <h3 class="wishlist-title"><%# Eval("product_name") %></h3>
                                <div class="wishlist-price">&#8377; <%# String.Format("{0:N0}", Eval("price")) %></div>
                                <div class="wishlist-size-box">
                                    <div class="size-box-title">
                                        <i class="fa-solid fa-ruler-horizontal"></i> Select Size:
                                    </div>
                                    <div class="size-selector-row" id='<%# "sizeGroup_" + Eval("product_id") %>'>
                                        <button type="button" class="btn-wishlist-size" data-size="S" onclick='<%# "selectWishlistSize(" + Eval("product_id") + ", \"S\", this)" %>'>S</button>
                                        <button type="button" class="btn-wishlist-size active" data-size="M" onclick='<%# "selectWishlistSize(" + Eval("product_id") + ", \"M\", this)" %>'>M</button>
                                        <button type="button" class="btn-wishlist-size" data-size="L" onclick='<%# "selectWishlistSize(" + Eval("product_id") + ", \"L\", this)" %>'>L</button>
                                        <button type="button" class="btn-wishlist-size" data-size="XL" onclick='<%# "selectWishlistSize(" + Eval("product_id") + ", \"XL\", this)" %>'>XL</button>
                                        <button type="button" class="btn-wishlist-size" data-size="XXL" onclick='<%# "selectWishlistSize(" + Eval("product_id") + ", \"XXL\", this)" %>'>XXL</button>
                                    </div>
                                    <input type="hidden" id='<%# "hdnWishlistSize_" + Eval("product_id") %>' value="M" />
                                </div>
                                <div class="wishlist-actions">
                                    <button type="button" onclick='<%# "addToCartFromWishlist(" + Eval("product_id") + ")" %>' class="btn-move-cart">
                                        <i class="fa-solid fa-cart-plus"></i> Add to Cart
                                    </button>
                                    <a href='<%# "productdetails.aspx?id=" + Eval("product_id") %>' class="btn-view-prod">
                                        <i class="fa-solid fa-eye"></i> View Details
                                    </a>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        <% } %>
    </div>

    <script>
        function selectWishlistSize(productId, size, btnElem) {
            var group = document.getElementById('sizeGroup_' + productId);
            if (group) {
                var buttons = group.querySelectorAll('.btn-wishlist-size');
                for (var i = 0; i < buttons.length; i++) {
                    buttons[i].classList.remove('active');
                }
            }
            btnElem.classList.add('active');
            var hdn = document.getElementById('hdnWishlistSize_' + productId);
            if (hdn) {
                hdn.value = size;
            }
        }

        function addToCartFromWishlist(productId) {
            var hdn = document.getElementById('hdnWishlistSize_' + productId);
            var size = hdn ? hdn.value : 'M';
            window.location.href = 'cart.aspx?action=add&id=' + productId + '&size=' + encodeURIComponent(size);
        }
    </script>
</asp:Content>
