require "csv"
require "prawn"
require "prawn/table"
require "cgi"

class ReportsController < AuthenticatedController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped
  before_action :authorize_report

  REPORT_TYPES = %w[daily weekly monthly custom truck_wise driver_wise].freeze

  def index
    @report_type = REPORT_TYPES.include?(params[:report_type]) ? params[:report_type] : "daily"
    send("load_#{@report_type}_report")
    respond_to_format(report_filename)
  end

  private

  def authorize_report
    authorize :report, :index?
  end

  def load_daily_report
    @date = parse_date(params[:date]) || Date.current
    @start_date = @date
    @end_date = @date
    load_filtered_shipments
    @shipments = @shipments.order(:shipment_date, :shipment_number)
    load_stats
  end

  def load_weekly_report
    @start_date = Date.current - 6.days
    @end_date = Date.current
    load_filtered_shipments
    @grouped = @shipments.group(:shipment_date, :shipment_type).count
  end

  def load_monthly_report
    @date = parse_date(params[:date]) || Date.current
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
    load_filtered_shipments
    @grouped = @shipments.group(:shipment_type, :status).count
  end

  def load_custom_report
    @start_date = parse_date(params[:start_date]) || Date.current
    @end_date = parse_date(params[:end_date]) || Date.current
    @start_date, @end_date = @end_date, @start_date if @end_date < @start_date
    load_filtered_shipments
    @shipments = @shipments.order(:shipment_date, :shipment_number)
    load_stats
  end

  def load_truck_wise_report
    @truck = Truck.kept.find(params[:truck_id]) if params[:truck_id].present?
    @trucks = Truck.kept.order(:truck_number)
    @shipments = @truck ? @truck.shipments.kept : Shipment.kept
    if params[:from_date].present?
      range = date_range
      @shipments = @shipments.where(shipment_date: range) if range
    end
    @shipments = @shipments.where(status: params[:status]) if params[:status].present?
    @start_date = parse_date(params[:from_date])
    @end_date = parse_date(params[:to_date])
    @grouped = @shipments.group(:truck_id, :status).count
  end

  def load_driver_wise_report
    @driver = Driver.kept.find(params[:driver_id]) if params[:driver_id].present?
    @drivers = Driver.kept.order(:name)
    @assignments = @driver ? @driver.driver_assignments : DriverAssignment.all
    if params[:from_date].present?
      range = date_range
      @assignments = @assignments.where(assigned_at: range) if range
    end
    @start_date = parse_date(params[:from_date])
    @end_date = parse_date(params[:to_date])
    @assignments = @assignments.includes(:driver, :truck).order(assigned_at: :desc)
  end

  def load_filtered_shipments
    @locations = Location.kept.order(:name)
    @trucks = Truck.kept.order(:truck_number)
    @shipments = Shipment.kept.includes(:source_location, :destination_location, :truck)
                         .where(shipment_date: @start_date..@end_date)
    @shipments = @shipments.where(shipment_type: params[:type]) if params[:type].present?
    @shipments = @shipments.where(source_location_id: params[:source_id]) if params[:source_id].present?
    @shipments = @shipments.where(destination_location_id: params[:destination_id]) if params[:destination_id].present?
    @shipments = @shipments.where(truck_id: params[:truck_id]) if params[:truck_id].present?
    @shipments = @shipments.where(status: params[:status]) if params[:status].present?
  end

  def load_stats
    @exports = @shipments.exports.count
    @imports = @shipments.imports.count
    @completed = @shipments.where(status: "completed").count
    @on_way = @shipments.where(status: "on_the_way").count
  end

  def date_range
    (Date.parse(params[:from_date])..Date.parse(params[:to_date]))
  rescue
    nil
  end

  def parse_date(value)
    Date.parse(value) if value.present?
  rescue ArgumentError
    nil
  end

  def report_filename
    case @report_type
    when "daily"    then "Daily_Report_#{@start_date}"
    when "weekly"   then "Weekly_Report_#{@start_date}_#{@end_date}"
    when "monthly"  then "Monthly_Report_#{@start_date&.strftime('%B_%Y')}"
    when "custom"   then "Custom_Report_#{@start_date}_#{@end_date}"
    when "truck_wise"  then "Truck_Wise_Report"
    when "driver_wise" then "Driver_Wise_Report"
    end
  end

  def respond_to_format(filename)
    respond_to do |format|
      format.html
      format.csv  { send_data generate_csv,  filename: "#{filename}.csv",  type: "text/csv; charset=utf-8" }
      format.pdf  { send_data generate_pdf(filename), filename: "#{filename}.pdf",  type: "application/pdf", disposition: "attachment" }
      format.docx { send_data generate_docx(filename), filename: "#{filename}.docx", type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", disposition: "attachment" }
    end
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << export_headers
      export_rows.each { |row| csv << row }
    end
  end

  def generate_pdf(title)
    Prawn::Document.new(page_layout: :landscape) do |pdf|
      pdf.text title.humanize, size: 18, style: :bold
      pdf.move_down 12
      rows = [export_headers] + export_rows
      pdf.table(rows, header: true, width: pdf.bounds.width, cell_style: { size: 9, padding: 6 }) do
        row(0).font_style = :bold
        row(0).background_color = "F3F4F6"
      end
    end.render
  end

  def generate_docx(title)
    require "zip"
    Zip::OutputStream.write_buffer do |zip|
      zip.put_next_entry("[Content_Types].xml")
      zip.write content_types_xml
      zip.put_next_entry("_rels/.rels")
      zip.write rels_xml
      zip.put_next_entry("word/document.xml")
      zip.write word_document_xml(title)
    end.string
  rescue LoadError
    generate_docx_html(title)
  end

  def generate_docx_html(title)
    header_cells = export_headers.map { |h| "<th>#{CGI.escapeHTML(h)}</th>" }.join
    rows = export_rows.map do |row|
      cells = row.map { |v| "<td>#{CGI.escapeHTML(v.to_s)}</td>" }.join
      "<tr>#{cells}</tr>"
    end.join
    <<~HTML
      <!doctype html>
      <html><head><meta charset="utf-8"><title>#{CGI.escapeHTML(title.humanize)}</title></head>
      <body><h1>#{CGI.escapeHTML(title.humanize)}</h1>
      <table border="1" cellspacing="0" cellpadding="6"><thead><tr>#{header_cells}</tr></thead><tbody>#{rows}</tbody></table></body></html>
    HTML
  end

  def content_types_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
        <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
        <Default Extension="xml" ContentType="application/xml"/>
        <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
      </Types>
    XML
  end

  def rels_xml
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
        <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
      </Relationships>
    XML
  end

  def word_document_xml(title)
    header_cells = export_headers.map { |h| word_table_cell(h, bold: true) }.join
    rows = export_rows.map do |row|
      "<w:tr>#{row.map { |v| word_table_cell(v) }.join}</w:tr>"
    end.join
    <<~XML
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
        <w:body>
          <w:p><w:r><w:rPr><w:b/></w:rPr><w:t>#{xml_escape(title.humanize)}</w:t></w:r></w:p>
          <w:tbl>
            <w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders><w:top w:val="single" w:sz="4"/><w:left w:val="single" w:sz="4"/><w:bottom w:val="single" w:sz="4"/><w:right w:val="single" w:sz="4"/><w:insideH w:val="single" w:sz="4"/><w:insideV w:val="single" w:sz="4"/></w:tblBorders></w:tblPr>
            <w:tr>#{header_cells}</w:tr>
            #{rows}
          </w:tbl>
        </w:body>
      </w:document>
    XML
  end

  def word_table_cell(value, bold: false)
    bold_tag = bold ? "<w:rPr><w:b/></w:rPr>" : ""
    "<w:tc><w:p><w:r>#{bold_tag}<w:t>#{xml_escape(value.to_s)}</w:t></w:r></w:p></w:tc>"
  end

  def xml_escape(value)
    CGI.escapeHTML(value)
  end

  def export_headers
    case @report_type
    when "daily", "weekly", "monthly", "custom", "truck_wise"
      ["Shipment #", "Type", "Status", "Source", "Destination", "Truck", "Date"]
    when "driver_wise"
      ["Driver", "Truck", "Assigned At", "Released At"]
    end
  end

  def export_rows
    case @report_type
    when "daily", "weekly", "monthly", "custom", "truck_wise"
      export_data.map do |s|
        [s.shipment_number, s.shipment_type&.titleize, s.status&.titleize,
         s.source_location&.name, s.destination_location&.name,
         s.truck&.truck_number, s.shipment_date]
      end
    when "driver_wise"
      export_data.map do |a|
        [a.driver&.name, a.truck&.truck_number, a.assigned_at, a.released_at]
      end
    end
  end

  def export_data
    case @report_type
    when "daily", "weekly", "monthly", "custom", "truck_wise" then @shipments || Shipment.none
    when "driver_wise" then @assignments || DriverAssignment.none
    end
  end
end
