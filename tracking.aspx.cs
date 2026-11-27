using System;
using System.Data;
using System.Web.UI;
using System.Data.SqlClient;

namespace textiles
{
    public partial class tracking : Page
    {
        public string OrderStatus = "Processing";
        public int StepIndex = 3; // 1: Placed, 2: Confirmed, 3: Processing, 4: Packed, 5: Shipped, 6: OutForDelivery, 7: Delivered

        public string Step1Time = "";
        public string Step2Time = "";
        public string Step3Time = "";
        public string Step4Time = "";
        public string Step5Time = "";
        public string Step6Time = "";
        public string Step7Time = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderNum = Request.QueryString["order"];
                if (string.IsNullOrEmpty(orderNum) && Session["LastOrderNumber"] != null)
                {
                    orderNum = Session["LastOrderNumber"].ToString();
                }

                if (string.IsNullOrEmpty(orderNum) && Session["UserEmail"] != null)
                {
                    try
                    {
                        object latestOrd = DbHelper.ExecuteScalar(
                            "SELECT TOP 1 order_number FROM orders WHERE user_email=@email ORDER BY id DESC",
                            new SqlParameter("@email", Session["UserEmail"].ToString()));
                        if (latestOrd != null) orderNum = latestOrd.ToString();
                    }
                    catch { }
                }

                if (string.IsNullOrEmpty(orderNum))
                {
                    try
                    {
                        object latestOrd = DbHelper.ExecuteScalar("SELECT TOP 1 order_number FROM orders ORDER BY id DESC");
                        if (latestOrd != null) orderNum = latestOrd.ToString();
                    }
                    catch { }
                }

                if (!string.IsNullOrEmpty(orderNum))
                {
                    txtTrackOrder.Text = orderNum;
                    LoadTracking(orderNum);
                }
                else
                {
                    pnlTrackingResult.Visible = false;
                    lblTrackingMsg.Text = "Please enter an Order ID to track your package.";
                    lblTrackingMsg.Visible = true;
                }
            }
        }

        protected void btnTrack_Click(object sender, EventArgs e)
        {
            string orderNum = txtTrackOrder.Text.Trim();
            if (!string.IsNullOrEmpty(orderNum))
            {
                LoadTracking(orderNum);
            }
            else
            {
                pnlTrackingResult.Visible = false;
                lblTrackingMsg.Text = "Please enter a valid Order ID.";
                lblTrackingMsg.Visible = true;
            }
        }

        private void LoadTracking(string orderNumber)
        {
            try
            {
                string sql = "SELECT TOP 1 * FROM orders WHERE order_number=@ordNum OR CAST(id AS NVARCHAR(50))=@ordNum";
                DataTable dt = DbHelper.ExecuteDataTable(sql, new SqlParameter("@ordNum", orderNumber));

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    string ordNum = r["order_number"].ToString();
                    txtTrackOrder.Text = ordNum;
                    lblOrderId.Text = ordNum;

                    DateTime createdAt = Convert.ToDateTime(r["created_at"]);
                    lblOrderDate.Text = createdAt.ToString("dd-MMM-yyyy, hh:mm tt");
                    lblTotalAmount.Text = Convert.ToDecimal(r["total_amount"]).ToString("N0");

                    string pm = r["payment_method"] != null ? r["payment_method"].ToString() : "";
                    if (pm.IndexOf("Razorpay", StringComparison.OrdinalIgnoreCase) >= 0 || pm.Equals("Online", StringComparison.OrdinalIgnoreCase))
                    {
                        lblPaymentMethod.Text = "Online Payment (Razorpay / UPI)";
                    }
                    else
                    {
                        lblPaymentMethod.Text = "Cash on Delivery (COD)";
                    }

                    lblCustomerName.Text = r["customer_name"].ToString();
                    lblAddress.Text = r["address"].ToString();
                    lblPhone.Text = r["phone"].ToString();
                    lblCourier.Text = "BlueDart Express";
                    lblAwb.Text = "BLUEDART-" + Math.Abs(ordNum.GetHashCode()).ToString().PadLeft(8, '0').Substring(0, 8);

                    // Fetch real items
                    int orderId = Convert.ToInt32(r["id"]);
                    DataTable dtItems = DbHelper.ExecuteDataTable("SELECT product_name, price, quantity, size, total FROM order_items WHERE order_id=@oid", new SqlParameter("@oid", orderId));
                    if (dtItems != null && dtItems.Rows.Count > 0)
                    {
                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("<div style='display:flex; flex-direction:column; gap:6px;'>");
                        foreach (DataRow ir in dtItems.Rows)
                        {
                            string pName = Server.HtmlEncode(ir["product_name"].ToString());
                            int qty = Convert.ToInt32(ir["quantity"]);
                            string size = ir["size"] != DBNull.Value ? ir["size"].ToString().ToUpper() : "M";
                            decimal total = Convert.ToDecimal(ir["total"]);

                            sb.Append("<div style='display:flex; justify-content:space-between; align-items:center; background:#f8fafc; border:1px solid #e2e8f0; border-radius:6px; padding:6px 10px; font-size:13px;'>");
                            sb.Append($"<span><strong>{pName}</strong> &nbsp;<span style='background:#e0e7ff; color:#3730a3; padding:1px 6px; border-radius:4px; font-size:11px; font-weight:700;'>Size {size}</span> &times; <strong>{qty}</strong></span>");
                            sb.Append($"<span style='font-weight:700; color:#1e293b;'>&#8377;{total:N0}</span>");
                            sb.Append("</div>");
                        }
                        sb.Append("</div>");
                        lblItemsList.Text = sb.ToString();
                    }
                    else
                    {
                        lblItemsList.Text = "<span style='color:#64748b;'>Package Details Confirmed</span>";
                    }

                    OrderStatus = r["order_status"].ToString();
                    SetStepIndex(OrderStatus);
                    ComputeStepTimestamps(createdAt, StepIndex);

                    pnlTrackingResult.Visible = true;
                    lblTrackingMsg.Visible = false;
                    return;
                }
            }
            catch (Exception ex)
            {
                lblTrackingMsg.Text = "Error loading tracking details: " + ex.Message;
                lblTrackingMsg.Visible = true;
                pnlTrackingResult.Visible = false;
                return;
            }

            pnlTrackingResult.Visible = false;
            lblTrackingMsg.Text = $"No order found for ID \"{Server.HtmlEncode(orderNumber)}\". Please verify your order reference.";
            lblTrackingMsg.Visible = true;
        }

        private void SetStepIndex(string status)
        {
            switch (status.Trim().ToLower())
            {
                case "delivered":
                case "completed":
                    StepIndex = 7;
                    break;
                case "out for delivery":
                    StepIndex = 6;
                    break;
                case "shipped":
                    StepIndex = 5;
                    break;
                case "packed":
                    StepIndex = 4;
                    break;
                case "processing":
                    StepIndex = 3;
                    break;
                case "confirmed":
                case "payment confirmed":
                    StepIndex = 2;
                    break;
                case "pending":
                case "order placed":
                    StepIndex = 1;
                    break;
                default:
                    StepIndex = 3;
                    break;
            }
        }

        private void ComputeStepTimestamps(DateTime orderTime, int currentStep)
        {
            Step1Time = orderTime.ToString("dd MMM, hh:mm tt");
            Step2Time = (currentStep >= 2) ? orderTime.AddMinutes(5).ToString("dd MMM, hh:mm tt") : "Pending";
            Step3Time = (currentStep >= 3) ? (currentStep == 3 ? "In Production" : orderTime.AddHours(2).ToString("dd MMM, hh:mm tt")) : "Pending";
            Step4Time = (currentStep >= 4) ? (currentStep == 4 ? "Packed & Ready" : orderTime.AddDays(1).ToString("dd MMM, hh:mm tt")) : "Expected " + orderTime.AddDays(1).ToString("dd MMM");
            Step5Time = (currentStep >= 5) ? (currentStep == 5 ? "In Transit" : orderTime.AddDays(2).ToString("dd MMM, hh:mm tt")) : "Expected " + orderTime.AddDays(2).ToString("dd MMM");
            Step6Time = (currentStep >= 6) ? (currentStep == 6 ? "Out for Delivery Today" : orderTime.AddDays(3).ToString("dd MMM, hh:mm tt")) : "Expected " + orderTime.AddDays(3).ToString("dd MMM");
            Step7Time = (currentStep >= 7) ? orderTime.AddDays(3).ToString("dd MMM, hh:mm tt") : "Expected " + orderTime.AddDays(4).ToString("dd MMM");
        }
    }
}
