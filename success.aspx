<%@ Page Title="Order Confirmed - TEXTILES"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="success.aspx.cs"
    Inherits="textiles.success" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        /* ================= FULLSCREEN CONFETTI CANVAS ================= */
        #confettiCanvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            pointer-events: none;
            z-index: 9999;
        }

        .success-page-wrapper {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px 80px;
            position: relative;
            background: linear-gradient(180deg, #f8fafc 0%, #eef2f6 100%);
        }

        /* ================= MAIN SUCCESS CARD (BOUNCY ENTRANCE) ================= */
        .success-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 20px;
            padding: 45px 40px;
            max-width: 660px;
            width: 100%;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.08);
            position: relative;
            z-index: 10;
            animation: cardEntrance 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
            overflow: hidden;
        }

        .success-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, #1565c0, #2e7d32, #f59e0b, #1565c0);
            background-size: 300% 100%;
            animation: gradientBorder 4s infinite linear;
        }

        @keyframes cardEntrance {
            0% {
                opacity: 0;
                transform: scale(0.85) translateY(40px);
            }
            70% {
                transform: scale(1.02) translateY(-6px);
            }
            100% {
                opacity: 1;
                transform: scale(1) translateY(0);
            }
        }

        @keyframes gradientBorder {
            0% { background-position: 0% 50%; }
            100% { background-position: 300% 50%; }
        }

        /* ================= ANIMATED CHECKMARK & RIPPLE WAVES ================= */
        .check-animation-container {
            position: relative;
            width: 110px;
            height: 110px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ripple-ring {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: rgba(46, 125, 50, 0.2);
            animation: rippleWave 2.4s infinite cubic-bezier(0.1, 0.8, 0.3, 1);
        }

        .ripple-ring:nth-child(2) {
            animation-delay: 0.8s;
        }

        @keyframes rippleWave {
            0% {
                transform: scale(0.8);
                opacity: 0.9;
            }
            100% {
                transform: scale(1.8);
                opacity: 0;
            }
        }

        .svg-checkmark {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            display: block;
            stroke-width: 3.5;
            stroke: #2e7d32;
            stroke-miterlimit: 10;
            box-shadow: inset 0px 0px 0px #2e7d32;
            animation: fillCircle 0.4s ease-in-out 0.4s forwards, scaleCheck 0.3s ease-in-out 0.9s both;
            position: relative;
            z-index: 2;
        }

        .svg-circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 3.5;
            stroke-miterlimit: 10;
            stroke: #2e7d32;
            fill: none;
            animation: strokeCircle 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .svg-check {
            transform-origin: 50% 50%;
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: strokeCheck 0.4s cubic-bezier(0.65, 0, 0.45, 1) 0.6s forwards;
            stroke: #ffffff;
        }

        @keyframes strokeCircle {
            100% { stroke-dashoffset: 0; }
        }

        @keyframes strokeCheck {
            100% { stroke-dashoffset: 0; }
        }

        @keyframes fillCircle {
            100% { box-shadow: inset 0px 0px 0px 50px #2e7d32; }
        }

        @keyframes scaleCheck {
            0%, 100% { transform: none; }
            50% { transform: scale3d(1.15, 1.15, 1); }
        }

        /* ================= STATUS PILL & HEADINGS ================= */
        .confirmed-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #bbf7d0;
            font-size: 12px;
            font-weight: 800;
            padding: 5px 14px;
            border-radius: 20px;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
        }

        .beacon-dot {
            width: 8px;
            height: 8px;
            background: #16a34a;
            border-radius: 50%;
            box-shadow: 0 0 0 0 rgba(22, 163, 74, 0.7);
            animation: beaconPulse 1.6s infinite;
        }

        @keyframes beaconPulse {
            0% { box-shadow: 0 0 0 0 rgba(22, 163, 74, 0.7); }
            70% { box-shadow: 0 0 0 8px rgba(22, 163, 74, 0); }
            100% { box-shadow: 0 0 0 0 rgba(22, 163, 74, 0); }
        }

        .success-title {
            font-size: 27px;
            font-weight: 800;
            color: #1e293b;
            margin-bottom: 8px;
        }

        .success-subtitle {
            color: #64748b;
            font-size: 14.5px;
            margin-bottom: 24px;
            line-height: 1.5;
        }

        /* ================= ANIMATED DELIVERY JOURNEY TRACKER ================= */
        .journey-tracker {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 18px 20px;
            margin-bottom: 26px;
            text-align: left;
        }

        .journey-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .journey-header span {
            font-size: 13px;
            font-weight: 700;
            color: #1e293b;
        }

        .journey-track-bar {
            position: relative;
            height: 6px;
            background: #e2e8f0;
            border-radius: 3px;
            margin: 18px 10px 10px;
        }

        .journey-progress {
            height: 100%;
            width: 14%;
            background: #2e7d32;
            border-radius: 3px;
            transition: width 1s ease;
        }

        .journey-steps {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 11.5px;
            font-weight: 600;
            color: #64748b;
        }

        .journey-steps span.active {
            color: #1565c0;
            font-weight: 700;
        }

        /* ================= ORDER DETAILS TABLE ================= */
        .order-summary-box-figma {
            background: #ffffff;
            border: 1.5px solid #dbeafe;
            border-radius: 14px;
            padding: 22px 24px;
            text-align: left;
            margin-bottom: 26px;
            box-shadow: 0 4px 14px rgba(21, 101, 192, 0.04);
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 9px 0;
            border-bottom: 1px dashed #e2e8f0;
            font-size: 13.5px;
        }

        .detail-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .detail-row:first-child {
            padding-top: 0;
        }

        .detail-label {
            color: #64748b;
            font-weight: 500;
        }

        .detail-value {
            color: #1e293b;
            font-weight: 700;
        }

        .detail-value.order-num-highlight {
            color: #1565c0;
            font-family: monospace;
            font-size: 15px;
            background: #eff6ff;
            padding: 3px 8px;
            border-radius: 6px;
            border: 1px solid #bfdbfe;
        }

        /* ================= ACTION BUTTONS ================= */
        .success-actions {
            display: flex;
            gap: 12px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn-track-order {
            background: #1565c0;
            color: #ffffff;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(21, 101, 192, 0.25);
        }

        .btn-track-order:hover {
            background: #0d47a1;
            transform: translateY(-1px);
        }

        .btn-download-invoice {
            background: #ffffff;
            color: #1565c0;
            border: 1.5px solid #1565c0;
            padding: 12px 22px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-download-invoice:hover {
            background: #f0f7ff;
            transform: translateY(-1px);
        }

        .btn-continue {
            background: #f8fafc;
            color: #475569;
            border: 1px solid #cbd5e1;
            padding: 12px 22px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 14px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-continue:hover {
            background: #e2e8f0;
        }

        /* PRINT STYLING */
        @media print {
            body * { visibility: hidden; }
            .success-card, .success-card * { visibility: visible; }
            .success-card { position: absolute; left: 0; top: 0; width: 100%; border: none; box-shadow: none; }
            .success-actions, .journey-tracker, #confettiCanvas { display: none !important; }
        }
    </style>

    <!-- CELEBRATION CONFETTI CANVAS -->
    <canvas id="confettiCanvas"></canvas>

    <div class="success-page-wrapper">
        <div class="success-card">
            
            <!-- ANIMATED CHECKMARK BADGE -->
            <div class="check-animation-container">
                <div class="ripple-ring"></div>
                <div class="ripple-ring"></div>
                <svg class="svg-checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
                    <circle class="svg-circle" cx="26" cy="26" r="25" fill="none" />
                    <path class="svg-check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8" />
                </svg>
            </div>

            <!-- STATUS PILL -->
            <div class="confirmed-badge">
                <span class="beacon-dot"></span> Order Placed &amp; Confirmed
            </div>

            <h1 class="success-title">Order Placed Successfully!</h1>
            <p class="success-subtitle">
                Thank you for your purchase with <strong>TEXTILES</strong>! Your payment has been processed and your garment package is now in production.
            </p>

            <!-- ANIMATED ORDER JOURNEY TRACKER -->
            <div class="journey-tracker">
                <div class="journey-header">
                    <span><i class="fa-solid fa-circle-check" style="color:#2e7d32; margin-right:6px;"></i> Order Status: <strong>Order Placed &amp; Confirmed</strong></span>
                    <span style="color:#2e7d32; font-size:12px; font-weight:700;"><i class="fa-solid fa-shield-check"></i> Verified</span>
                </div>
                <div class="journey-track-bar">
                    <div class="journey-progress"></div>
                </div>
                <div class="journey-steps">
                    <span class="active"><i class="fa-solid fa-circle-check"></i> Order Placed</span>
                    <span><i class="fa-solid fa-box"></i> Packed</span>
                    <span><i class="fa-solid fa-truck"></i> On the Way</span>
                    <span><i class="fa-solid fa-house"></i> Delivered</span>
                </div>
            </div>

            <!-- ORDER SUMMARY BOX (FIGMA FIGURE 10) -->
            <div class="order-summary-box-figma">
                <div class="detail-row">
                    <span class="detail-label">Order Reference:</span>
                    <span class="detail-value order-num-highlight"><asp:Label ID="lblOrderNumber" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Customer Name:</span>
                    <span class="detail-value"><asp:Label ID="lblCustomerName" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Registered Email:</span>
                    <span class="detail-value"><asp:Label ID="lblCustomerEmail" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Payment Gateway:</span>
                    <span class="detail-value" style="color:#1565c0;"><asp:Label ID="lblPaymentMethod" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Total Amount Paid:</span>
                    <span class="detail-value" style="font-size:16px; color:#2e7d32;">&#8377; <asp:Label ID="lblTotalAmount" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Order Fulfillment:</span>
                    <span class="detail-value" style="color: #2e7d32;"><i class="fa-solid fa-circle-check"></i> <asp:Label ID="lblOrderStatus" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Order Placed On:</span>
                    <span class="detail-value"><asp:Label ID="lblOrderDate" runat="server"></asp:Label></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Estimated Delivery:</span>
                    <span class="detail-value">3 &ndash; 5 Business Days (Express)</span>
                </div>
            </div>

            <!-- ACTIONS -->
            <div class="success-actions">
                <asp:HyperLink ID="lnkTrackOrder" runat="server" CssClass="btn-track-order">
                    <i class="fa-solid fa-location-crosshairs"></i> Track Live Status
                </asp:HyperLink>
                <button type="button" class="btn-download-invoice" onclick="window.print();">
                    <i class="fa-solid fa-file-invoice"></i> Print Invoice
                </button>
                <a href="product.aspx" class="btn-continue">
                    <i class="fa-solid fa-bag-shopping"></i> Continue Shopping
                </a>
            </div>
        </div>
    </div>

    <!-- CELEBRATION SCRIPT & SOUND CHIME -->
    <script>
        // 1. Victory Chime using Web Audio API
        function playSuccessChime() {
            try {
                var AudioContext = window.AudioContext || window.webkitAudioContext;
                if (!AudioContext) return;
                var ctx = new AudioContext();

                function playNote(freq, time, duration) {
                    var osc = ctx.createOscillator();
                    var gain = ctx.createGain();
                    osc.type = 'triangle';
                    osc.frequency.setValueAtTime(freq, time);
                    gain.gain.setValueAtTime(0.001, time);
                    gain.gain.exponentialRampToValueAtTime(0.2, time + 0.05);
                    gain.gain.exponentialRampToValueAtTime(0.001, time + duration);
                    osc.connect(gain);
                    gain.connect(ctx.destination);
                    osc.start(time);
                    osc.stop(time + duration);
                }

                var now = ctx.currentTime;
                playNote(523.25, now + 0.05, 0.25); // C5
                playNote(659.25, now + 0.22, 0.25); // E5
                playNote(783.99, now + 0.40, 0.50); // G5
                playNote(1046.50, now + 0.58, 0.70); // C6
            } catch (e) {
                // AudioContext autoplay restriction handled silently
            }
        }

        // 2. High-Fidelity Confetti Cannon System
        (function () {
            var canvas = document.getElementById('confettiCanvas');
            if (!canvas) return;
            var ctx = canvas.getContext('2d');
            var width = canvas.width = window.innerWidth;
            var height = canvas.height = window.innerHeight;

            window.addEventListener('resize', function () {
                width = canvas.width = window.innerWidth;
                height = canvas.height = window.innerHeight;
            });

            var particles = [];
            var colors = ['#1565c0', '#2e7d32', '#f59e0b', '#ec4899', '#8b5cf6', '#06b6d4', '#e11d48'];

            function createParticle(x, y) {
                return {
                    x: x || width / 2,
                    y: y || height / 2,
                    size: Math.random() * 8 + 5,
                    color: colors[Math.floor(Math.random() * colors.length)],
                    vx: (Math.random() - 0.5) * 16,
                    vy: Math.random() * -14 - 4,
                    rotation: Math.random() * 360,
                    rotationSpeed: (Math.random() - 0.5) * 12,
                    shape: Math.random() > 0.5 ? 'rect' : 'circle',
                    gravity: 0.35,
                    opacity: 1
                };
            }

            // Burst 130 particles
            for (var i = 0; i < 130; i++) {
                particles.push(createParticle());
            }

            var startTime = Date.now();
            var duration = 4500; // 4.5 seconds celebration

            function render() {
                var elapsed = Date.now() - startTime;
                ctx.clearRect(0, 0, width, height);

                particles.forEach(function (p) {
                    p.x += p.vx;
                    p.y += p.vy;
                    p.vy += p.gravity;
                    p.rotation += p.rotationSpeed;
                    p.opacity = Math.max(0, 1 - (elapsed / duration));

                    ctx.save();
                    ctx.globalAlpha = p.opacity;
                    ctx.translate(p.x, p.y);
                    ctx.rotate((p.rotation * Math.PI) / 180);
                    ctx.fillStyle = p.color;

                    if (p.shape === 'rect') {
                        ctx.fillRect(-p.size / 2, -p.size / 2, p.size, p.size * 1.6);
                    } else {
                        ctx.beginPath();
                        ctx.arc(0, 0, p.size / 2, 0, Math.PI * 2);
                        ctx.fill();
                    }
                    ctx.restore();
                });

                if (elapsed < duration) {
                    requestAnimationFrame(render);
                } else {
                    ctx.clearRect(0, 0, width, height);
                }
            }

            render();
        })();

        // Trigger victory sound on user interaction or load
        window.addEventListener('load', function () {
            playSuccessChime();
        });
        document.addEventListener('click', function () {
            playSuccessChime();
        }, { once: true });
    </script>
</asp:Content>