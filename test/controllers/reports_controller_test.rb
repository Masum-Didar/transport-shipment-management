require "test_helper"
require "securerandom"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    admin_role = Role.find_or_create_by!(name: "admin") { |role| role.description = "Admin" }
    suffix = SecureRandom.hex(4)
    @user = create(:user, role: admin_role, email: "report-#{suffix}@example.com")
    sign_in @user

    @source = create(:location, name: "Chittagong Port #{suffix}")
    @destination = create(:location, name: "Dhaka ICD #{suffix}")
    @truck = create(:truck, truck_number: "DHK-#{suffix}")

    @shipment = create(
      :shipment,
      :export,
      :completed,
      shipment_number: "DR-001-#{suffix}",
      shipment_date: Date.new(2026, 7, 10),
      source_location: @source,
      destination_location: @destination,
      truck: @truck,
      created_by: @user
    )
  end

  test "index renders daily report by default" do
    get reports_path
    assert_response :success
    assert_includes response.body, "Daily Report"
  end

  test "daily report filters by date and dropdown params" do
    get reports_path(
      report_type: "daily",
      date: "2026-07-10",
      type: "export",
      source_id: @source.id,
      destination_id: @destination.id,
      truck_id: @truck.id,
      status: "completed"
    )

    assert_response :success
    assert_includes response.body, @shipment.shipment_number
  end

  test "daily csv export" do
    get reports_path(report_type: "daily", format: :csv, date: "2026-07-10")

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.body, "Shipment #,Type,Status,Source,Destination,Truck,Date"
    assert_includes response.body, @shipment.shipment_number
  end

  test "daily pdf export" do
    get reports_path(report_type: "daily", format: :pdf, date: "2026-07-10")

    assert_response :success
    assert_equal "application/pdf", response.media_type
    assert response.body.start_with?("%PDF")
  end

  test "daily docx export" do
    get reports_path(report_type: "daily", format: :docx, date: "2026-07-10")

    assert_response :success
    assert_equal "application/vnd.openxmlformats-officedocument.wordprocessingml.document", response.media_type
    assert response.body.start_with?("PK")
  end

  test "weekly report renders" do
    get reports_path(report_type: "weekly")
    assert_response :success
    assert_includes response.body, "Weekly Report"
  end

  test "monthly report renders" do
    get reports_path(report_type: "monthly", date: "2026-07-01")
    assert_response :success
    assert_includes response.body, "Monthly Report"
  end

  test "custom report renders with date range" do
    get reports_path(report_type: "custom", start_date: "2026-07-01", end_date: "2026-07-31")
    assert_response :success
    assert_includes response.body, "Custom Report"
    assert_includes response.body, @shipment.shipment_number
  end

  test "custom csv export" do
    get reports_path(report_type: "custom", format: :csv, start_date: "2026-07-01", end_date: "2026-07-31")

    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.body, "Shipment #,Type,Status,Source,Destination,Truck,Date"
    assert_includes response.body, @shipment.shipment_number
  end

  test "truck wise report renders" do
    get reports_path(report_type: "truck_wise", truck_id: @truck.id)
    assert_response :success
    assert_includes response.body, "Truck Wise Report"
  end

  test "driver wise report renders" do
    get reports_path(report_type: "driver_wise")
    assert_response :success
    assert_includes response.body, "Driver Wise Report"
  end
end
