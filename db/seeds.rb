# Roles
roles = {
  "super_admin" => "Full system access. Can manage users, settings, and all data.",
  "admin"       => "Can manage all operations, reports, and settings. Cannot manage users.",
  "dispatcher"  => "Day-to-day operations: create/update shipments, assign trucks and drivers.",
  "operator"    => "Data entry: create shipments, update statuses.",
  "account"     => "View reports and shipment history for billing and accounting.",
  "viewer"      => "Read-only access to dashboard and reports."
}

roles.each do |name, description|
  Role.find_or_create_by!(name: name) do |r|
    r.description = description
  end
end

puts "=> Roles created: #{Role.pluck(:name).join(', ')}"

# Admin User
super_admin_role = Role.find_by!(name: "super_admin")
admin_role = Role.find_by!(name: "admin")

User.find_or_create_by!(email: "admin@tsm.com") do |u|
  u.password = "password123"
  u.name = "Super Admin"
  u.role = super_admin_role
  u.status = "active"
end

User.find_or_create_by!(email: "dispatcher@tsm.com") do |u|
  u.password = "password123"
  u.name = "Main Dispatcher"
  u.role = admin_role
  u.status = "active"
end

puts "=> Users created: #{User.pluck(:email).join(', ')}"
puts "   Login: admin@tsm.com / password123"

# Locations
locations = [
  { name: "Dhaka ICD",       location_type: "icd",     city: "Dhaka",       division: "Dhaka" },
  { name: "Chittagong Port", location_type: "port",    city: "Chattogram",  division: "Chattogram" },
  { name: "Benapole",         location_type: "border",  city: "Jessore",     division: "Khulna" },
  { name: "Mongla Port",      location_type: "port",    city: "Bagerhat",    division: "Khulna" },
  { name: "Kamalapur ICD",    location_type: "icd",     city: "Dhaka",       division: "Dhaka" },
  { name: "Burimari Land Port", location_type: "border", city: "Lalmonirhat", division: "Rangpur" },
  { name: "Pangaon Inland Port", location_type: "port",  city: "Dhaka",       division: "Dhaka" },
  { name: "Main Warehouse",   location_type: "warehouse", city: "Dhaka",      division: "Dhaka" },
]

locations.each do |loc|
  Location.find_or_create_by!(name: loc[:name]) do |l|
    l.location_type = loc[:location_type]
    l.city = loc[:city]
    l.division = loc[:division]
    l.country = "Bangladesh"
  end
end

puts "=> Locations created: #{Location.pluck(:name).join(', ')}"

# Routes
dhaka_icd = Location.find_by!(name: "Dhaka ICD")
ctg_port = Location.find_by!(name: "Chittagong Port")
benapole = Location.find_by!(name: "Benapole")
mongla = Location.find_by!(name: "Mongla Port")
warehouse = Location.find_by!(name: "Main Warehouse")

routes_data = [
  { from: dhaka_icd, to: ctg_port, dist: 264, hours: 6.0 },
  { from: ctg_port, to: dhaka_icd, dist: 264, hours: 6.0 },
  { from: dhaka_icd, to: benapole, dist: 340, hours: 7.5 },
  { from: benapole, to: dhaka_icd, dist: 340, hours: 7.5 },
  { from: dhaka_icd, to: mongla, dist: 320, hours: 7.0 },
  { from: warehouse, to: ctg_port, dist: 250, hours: 5.5 },
]

routes_data.each do |r|
  Route.find_or_create_by!(from_location: r[:from], to_location: r[:to]) do |route|
    route.distance_km = r[:dist]
    route.estimated_hours = r[:hours]
  end
end

puts "=> Routes created: #{Route.count}"

# Product Categories
categories = ["Grains", "Construction Materials", "Electronics", "Garments", "Machinery", "Food", "Beverage", "Others"]
categories.each do |cat|
  ProductCategory.find_or_create_by!(name: cat)
end

puts "=> Product Categories created: #{ProductCategory.pluck(:name).join(', ')}"

# Products
rice    = Product.find_or_create_by!(name: "Rice")      { |p| p.product_category = ProductCategory.find_by!(name: "Grains"); p.default_unit = "kg" }
wheat   = Product.find_or_create_by!(name: "Wheat")     { |p| p.product_category = ProductCategory.find_by!(name: "Grains"); p.default_unit = "kg" }
cement  = Product.find_or_create_by!(name: "Cement")    { |p| p.product_category = ProductCategory.find_by!(name: "Construction Materials"); p.default_unit = "kg" }
tiles   = Product.find_or_create_by!(name: "Tiles")     { |p| p.product_category = ProductCategory.find_by!(name: "Construction Materials"); p.default_unit = "piece" }
garments = Product.find_or_create_by!(name: "Garments") { |p| p.product_category = ProductCategory.find_by!(name: "Garments"); p.default_unit = "piece" }
machinery = Product.find_or_create_by!(name: "Machinery") { |p| p.product_category = ProductCategory.find_by!(name: "Machinery"); p.default_unit = "piece" }

puts "=> Products created: #{Product.pluck(:name).join(', ')}"

# Trucks
trucks_data = [
  { number: "D-1234", type: "company", brand: "Tata", model: "LPK 2518", year: 2022, capacity: 25000 },
  { number: "D-5678", type: "company", brand: "Ashok Leyland", model: "1920", year: 2023, capacity: 19000 },
  { number: "D-9012", type: "company", brand: "Eicher", model: "Pro 3015", year: 2021, capacity: 15000 },
  { number: "D-3456", type: "outside", brand: "Tata", model: "Signa 3525", year: 2024, capacity: 35000 },
  { number: "D-7890", type: "outside", brand: "Ashok Leyland", model: "4125", year: 2022, capacity: 25000 },
  { number: "D-2345", type: "company", brand: "Mahindra", model: "Blazo 28", year: 2023, capacity: 28000 },
]

trucks_data.each do |t|
  Truck.find_or_create_by!(truck_number: t[:number]) do |truck|
    truck.truck_type = t[:type]
    truck.brand = t[:brand]
    truck.vehicle_model = t[:model]
    truck.year = t[:year]
    truck.capacity_kg = t[:capacity]
    truck.status = "available"
    truck.current_location = dhaka_icd
  end
end

puts "=> Trucks created: #{Truck.pluck(:truck_number).join(', ')}"

# Drivers
drivers_data = [
  { name: "Abdul Karim",    phone: "01711111111", license: "D-12345" },
  { name: "Md. Rahim",      phone: "01722222222", license: "D-23456" },
  { name: "Hasan Ali",      phone: "01733333333", license: "D-34567" },
  { name: "Faruq Hossain",  phone: "01744444444", license: "D-45678" },
  { name: "Jamal Uddin",    phone: "01755555555", license: "D-56789" },
  { name: "Mizanur Rahman", phone: "01766666666", license: "D-67890" },
]

drivers_data.each do |d|
  Driver.find_or_create_by!(phone: d[:phone]) do |driver|
    driver.name = d[:name]
    driver.license_number = d[:license]
    driver.status = "available"
  end
end

puts "=> Drivers created: #{Driver.pluck(:name).join(', ')}"

# Settings
Setting.find_or_create_by!(key: "company_name") do |s|
  s.value = "TSM Transport Ltd."
  s.setting_type = "string"
  s.group = "company"
  s.description = "Company display name"
end

Setting.find_or_create_by!(key: "company_address") do |s|
  s.value = "123, Motijheel C/A, Dhaka-1000"
  s.setting_type = "string"
  s.group = "company"
  s.description = "Company address"
end

Setting.find_or_create_by!(key: "company_phone") do |s|
  s.value = "+880-2-9551234"
  s.setting_type = "string"
  s.group = "company"
  s.description = "Company phone number"
end

Setting.find_or_create_by!(key: "company_email") do |s|
  s.value = "info@tsmtransport.com"
  s.setting_type = "string"
  s.group = "company"
  s.description = "Company email"
end

Setting.find_or_create_by!(key: "default_currency") do |s|
  s.value = "BDT"
  s.setting_type = "string"
  s.group = "general"
  s.description = "Default currency for reports"
end

puts "=> Settings created: #{Setting.pluck(:key).join(', ')}"
puts ""
puts "============================================"
puts "  🌟 Seed completed successfully!"
puts "  Login: admin@tsm.com / password123"
puts "============================================"
