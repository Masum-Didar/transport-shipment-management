module ReportsHelper
  def report_type_options
    [
      ["Daily Report", "daily"],
      ["Weekly Report", "weekly"],
      ["Monthly Report", "monthly"],
      ["Truck Wise Report", "truck_wise"],
      ["Driver Wise Report", "driver_wise"],
      ["Custom Report", "custom"]
    ]
  end

  def shipment_status_options
    [["All Status", ""], ["Pending", "pending"], ["Loading", "loading"],
     ["Loaded", "loaded"], ["On The Way", "on_the_way"], ["Reached", "reached"],
     ["Unloading", "unloading"], ["Completed", "completed"]]
  end
end
