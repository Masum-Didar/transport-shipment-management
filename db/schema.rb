# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_07_02_063418) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.integer "auditable_id", null: false
    t.string "auditable_type", null: false
    t.jsonb "audited_changes"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id"
    t.index ["auditable_type", "auditable_id"], name: "index_audit_logs_on_auditable_type_and_auditable_id"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "driver_assignments", force: :cascade do |t|
    t.datetime "assigned_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "assigned_by_id", null: false
    t.datetime "created_at", null: false
    t.bigint "driver_id", null: false
    t.text "notes"
    t.string "release_reason"
    t.datetime "released_at"
    t.bigint "truck_id", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_by_id"], name: "index_driver_assignments_on_assigned_by_id"
    t.index ["driver_id", "released_at"], name: "index_driver_assignments_on_driver_id_and_released_at"
    t.index ["driver_id"], name: "index_driver_assignments_on_driver_id"
    t.index ["truck_id", "released_at"], name: "index_driver_assignments_on_truck_id_and_released_at"
    t.index ["truck_id"], name: "index_driver_assignments_on_truck_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.text "address"
    t.string "alternative_phone"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "license_number"
    t.string "name", null: false
    t.text "notes"
    t.string "phone", null: false
    t.string "status", default: "available", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_drivers_on_discarded_at"
    t.index ["phone"], name: "index_drivers_on_phone", unique: true, where: "(discarded_at IS NULL)"
    t.index ["status"], name: "index_drivers_on_status"
  end

  create_table "locations", force: :cascade do |t|
    t.text "address"
    t.string "city"
    t.string "country", default: "Bangladesh"
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.string "division"
    t.decimal "latitude", precision: 10, scale: 7
    t.string "location_type", null: false
    t.decimal "longitude", precision: 10, scale: 7
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_locations_on_discarded_at"
    t.index ["location_type"], name: "index_locations_on_location_type"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.boolean "read", default: false
    t.datetime "read_at"
    t.string "title", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable_type_and_notifiable_id"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_product_categories_on_discarded_at"
    t.index ["name"], name: "index_product_categories_on_name", unique: true, where: "(discarded_at IS NULL)"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "default_unit", default: "kg", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.string "name", null: false
    t.bigint "product_category_id"
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
    t.index ["name"], name: "index_products_on_name"
    t.index ["product_category_id"], name: "index_products_on_product_category_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "routes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "discarded_at"
    t.decimal "distance_km", precision: 8, scale: 2
    t.decimal "estimated_hours", precision: 5, scale: 1
    t.bigint "from_location_id", null: false
    t.text "notes"
    t.bigint "to_location_id", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_routes_on_discarded_at"
    t.index ["from_location_id", "to_location_id"], name: "idx_routes_from_to_unique", unique: true, where: "(discarded_at IS NULL)"
    t.index ["from_location_id"], name: "index_routes_on_from_location_id"
    t.index ["to_location_id"], name: "index_routes_on_to_location_id"
  end

  create_table "settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "group"
    t.string "key", null: false
    t.string "setting_type", default: "string"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["group"], name: "index_settings_on_group"
    t.index ["key"], name: "index_settings_on_key", unique: true
  end

  create_table "shipment_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.decimal "quantity", precision: 12, scale: 2, null: false
    t.text "remarks"
    t.bigint "shipment_id", null: false
    t.string "unit", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 12, scale: 2
    t.index ["product_id"], name: "index_shipment_items_on_product_id"
    t.index ["shipment_id", "product_id"], name: "index_shipment_items_on_shipment_id_and_product_id"
    t.index ["shipment_id"], name: "index_shipment_items_on_shipment_id"
  end

  create_table "shipment_status_logs", force: :cascade do |t|
    t.datetime "changed_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "changed_by_id", null: false
    t.datetime "created_at", null: false
    t.text "remarks"
    t.bigint "shipment_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["changed_by_id"], name: "index_shipment_status_logs_on_changed_by_id"
    t.index ["shipment_id", "changed_at"], name: "index_shipment_status_logs_on_shipment_id_and_changed_at"
    t.index ["shipment_id"], name: "index_shipment_status_logs_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.date "actual_delivery_date"
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "destination_location_id"
    t.datetime "discarded_at"
    t.date "estimated_delivery_date"
    t.text "notes"
    t.bigint "route_id"
    t.date "shipment_date", default: -> { "CURRENT_DATE" }, null: false
    t.string "shipment_number", null: false
    t.string "shipment_type", null: false
    t.bigint "source_location_id"
    t.string "status", default: "pending", null: false
    t.bigint "truck_id"
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_shipments_on_created_by_id"
    t.index ["destination_location_id"], name: "index_shipments_on_destination_location_id"
    t.index ["discarded_at"], name: "index_shipments_on_discarded_at"
    t.index ["route_id"], name: "index_shipments_on_route_id"
    t.index ["shipment_date"], name: "index_shipments_on_shipment_date"
    t.index ["shipment_number"], name: "index_shipments_on_shipment_number", unique: true
    t.index ["shipment_type", "status", "shipment_date"], name: "idx_shipments_type_status_date"
    t.index ["shipment_type"], name: "index_shipments_on_shipment_type"
    t.index ["source_location_id"], name: "index_shipments_on_source_location_id"
    t.index ["status"], name: "index_shipments_on_status"
    t.index ["truck_id"], name: "index_shipments_on_truck_id"
  end

  create_table "truck_location_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "latitude", precision: 10, scale: 7
    t.string "location", null: false
    t.datetime "logged_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.decimal "longitude", precision: 10, scale: 7
    t.text "notes"
    t.bigint "truck_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "updated_by_id"
    t.index ["truck_id", "logged_at"], name: "index_truck_location_logs_on_truck_id_and_logged_at"
    t.index ["truck_id"], name: "index_truck_location_logs_on_truck_id"
    t.index ["updated_by_id"], name: "index_truck_location_logs_on_updated_by_id"
  end

  create_table "trucks", force: :cascade do |t|
    t.string "brand"
    t.decimal "capacity_kg", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.bigint "current_location_id"
    t.datetime "discarded_at"
    t.text "notes"
    t.string "status", default: "available", null: false
    t.string "truck_number", null: false
    t.string "truck_type", default: "company", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_model"
    t.integer "year"
    t.index ["current_location_id"], name: "index_trucks_on_current_location_id"
    t.index ["discarded_at"], name: "index_trucks_on_discarded_at"
    t.index ["status"], name: "index_trucks_on_status"
    t.index ["truck_number"], name: "index_trucks_on_truck_number", unique: true, where: "(discarded_at IS NULL)"
    t.index ["truck_type"], name: "index_trucks_on_truck_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.datetime "discarded_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "name", null: false
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.bigint "role_id", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_users_on_discarded_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "audit_logs", "users"
  add_foreign_key "driver_assignments", "drivers"
  add_foreign_key "driver_assignments", "trucks"
  add_foreign_key "driver_assignments", "users", column: "assigned_by_id"
  add_foreign_key "notifications", "users"
  add_foreign_key "products", "product_categories"
  add_foreign_key "routes", "locations", column: "from_location_id"
  add_foreign_key "routes", "locations", column: "to_location_id"
  add_foreign_key "shipment_items", "products"
  add_foreign_key "shipment_items", "shipments"
  add_foreign_key "shipment_status_logs", "shipments"
  add_foreign_key "shipment_status_logs", "users", column: "changed_by_id"
  add_foreign_key "shipments", "locations", column: "destination_location_id"
  add_foreign_key "shipments", "locations", column: "source_location_id"
  add_foreign_key "shipments", "routes"
  add_foreign_key "shipments", "trucks"
  add_foreign_key "shipments", "users", column: "created_by_id"
  add_foreign_key "truck_location_logs", "trucks"
  add_foreign_key "truck_location_logs", "users", column: "updated_by_id"
  add_foreign_key "trucks", "locations", column: "current_location_id"
  add_foreign_key "users", "roles"
end
