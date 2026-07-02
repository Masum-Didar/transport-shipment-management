# Database Schema
## Transport & Shipment Management System — Rails 8 + PostgreSQL

---

## Table: `roles`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| name | varchar | NOT NULL, UNIQUE | super_admin, admin, dispatcher, operator, account, viewer |
| description | text | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:** `idx_roles_name` UNIQUE on `(name)`

---

## Table: `users`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| email | varchar | NOT NULL, UNIQUE | Devise default |
| encrypted_password | varchar | NOT NULL | Devise default |
| name | varchar | NOT NULL | |
| role_id | bigint | NOT NULL, FK → roles(id) | |
| phone | varchar | | |
| status | varchar | NOT NULL, DEFAULT 'active' | active, inactive |
| reset_password_token | varchar | UNIQUE | Devise |
| reset_password_sent_at | timestamptz | | Devise |
| remember_created_at | timestamptz | | Devise |
| sign_in_count | integer | DEFAULT 0 | Devise Trackable |
| current_sign_in_at | timestamptz | | Devise Trackable |
| last_sign_in_at | timestamptz | | Devise Trackable |
| current_sign_in_ip | inet | | Devise Trackable |
| last_sign_in_ip | inet | | Devise Trackable |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_users_email` UNIQUE on `(email)` WHERE `discarded_at IS NULL`
- `idx_users_reset_password_token` UNIQUE on `(reset_password_token)`
- `idx_users_role_id` on `(role_id)`
- `idx_users_discarded_at` on `(discarded_at)`

---

## Table: `locations`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| name | varchar | NOT NULL | Dhaka ICD, Chittagong Port, Benapole |
| address | text | | |
| city | varchar | | |
| division | varchar | | |
| country | varchar | DEFAULT 'Bangladesh' | |
| location_type | varchar | NOT NULL | port, icd, warehouse, factory, border, other |
| latitude | decimal(10,7) | | |
| longitude | decimal(10,7) | | |
| notes | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_locations_name` on `(name)`
- `idx_locations_type` on `(location_type)`
- `idx_locations_discarded_at` on `(discarded_at)`

---

## Table: `routes`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| from_location_id | bigint | NOT NULL, FK → locations(id) | |
| to_location_id | bigint | NOT NULL, FK → locations(id) | |
| distance_km | decimal(8,2) | | |
| estimated_hours | decimal(5,1) | | |
| notes | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_routes_from_to` UNIQUE on `(from_location_id, to_location_id)` WHERE `discarded_at IS NULL`
- `idx_routes_from_location` on `(from_location_id)`
- `idx_routes_to_location` on `(to_location_id)`

**Check:** `from_location_id != to_location_id`

---

## Table: `trucks`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| truck_number | varchar | NOT NULL, UNIQUE | e.g., "Dhaka Metro 12-3456" |
| truck_type | varchar | NOT NULL | company, outside |
| status | varchar | NOT NULL, DEFAULT 'available' | available, assigned, loading, on_route, maintenance, inactive |
| brand | varchar | | Tata, Ashok Leyland, etc. |
| model | varchar | | |
| year | integer | | |
| capacity_kg | decimal(10,2) | | Max load capacity |
| current_location_id | bigint | FK → locations(id) | Current location reference |
| notes | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_trucks_truck_number` UNIQUE on `(truck_number)` WHERE `discarded_at IS NULL`
- `idx_trucks_status` on `(status)`
- `idx_trucks_type` on `(truck_type)`
- `idx_trucks_current_location` on `(current_location_id)`
- `idx_trucks_discarded_at` on `(discarded_at)`

---

## Table: `truck_location_logs`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| truck_id | bigint | NOT NULL, FK → trucks(id) | |
| location | varchar | NOT NULL | Free text or from locations |
| latitude | decimal(10,7) | | |
| longitude | decimal(10,7) | | |
| logged_at | timestamptz | NOT NULL, DEFAULT NOW() | |
| updated_by_id | bigint | FK → users(id) | |
| notes | text | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_truck_location_logs_truck` on `(truck_id)`
- `idx_truck_location_logs_logged_at` on `(logged_at)`
- `idx_truck_location_logs_truck_time` on `(truck_id, logged_at)`

---

## Table: `drivers`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| name | varchar | NOT NULL | |
| phone | varchar | NOT NULL, UNIQUE | |
| alternative_phone | varchar | | |
| address | text | | |
| license_number | varchar | | |
| status | varchar | NOT NULL, DEFAULT 'available' | available, driving, leave, inactive |
| notes | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_drivers_phone` UNIQUE on `(phone)` WHERE `discarded_at IS NULL`
- `idx_drivers_status` on `(status)`
- `idx_drivers_discarded_at` on `(discarded_at)`

---

## Table: `driver_assignments`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| driver_id | bigint | NOT NULL, FK → drivers(id) | |
| truck_id | bigint | NOT NULL, FK → trucks(id) | |
| assigned_by_id | bigint | NOT NULL, FK → users(id) | |
| assigned_at | timestamptz | NOT NULL, DEFAULT NOW() | |
| released_at | timestamptz | | NULL = currently assigned |
| release_reason | varchar | | |
| notes | text | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_driver_assignments_driver` on `(driver_id)`
- `idx_driver_assignments_truck` on `(truck_id)`
- `idx_driver_assignments_active` on `(driver_id)` WHERE `released_at IS NULL`

---

## Table: `product_categories`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| name | varchar | NOT NULL, UNIQUE | |
| description | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_product_categories_name` UNIQUE on `(name)` WHERE `discarded_at IS NULL`

---

## Table: `products`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| name | varchar | NOT NULL | |
| product_category_id | bigint | FK → product_categories(id) | |
| default_unit | varchar | NOT NULL, DEFAULT 'kg' | kg, ton, piece, bag, liter |
| description | text | | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_products_name` on `(name)`
- `idx_products_category` on `(product_category_id)`
- `idx_products_discarded_at` on `(discarded_at)`

---

## Table: `shipments`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| shipment_number | varchar | NOT NULL, UNIQUE | Auto-generated: SH-2026-0001 |
| shipment_type | varchar | NOT NULL | import, export |
| source_location_id | bigint | FK → locations(id) | |
| destination_location_id | bigint | FK → locations(id) | |
| route_id | bigint | FK → routes(id) | |
| truck_id | bigint | FK → trucks(id) | |
| status | varchar | NOT NULL, DEFAULT 'pending' | pending, loading, loaded, on_the_way, reached, unloading, completed |
| shipment_date | date | NOT NULL, DEFAULT TODAY | |
| estimated_delivery_date | date | | |
| actual_delivery_date | date | | |
| notes | text | | |
| created_by_id | bigint | NOT NULL, FK → users(id) | |
| discarded_at | timestamptz | | Soft delete |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_shipments_number` UNIQUE on `(shipment_number)`
- `idx_shipments_type` on `(shipment_type)`
- `idx_shipments_status` on `(status)`
- `idx_shipments_date` on `(shipment_date)`
- `idx_shipments_truck` on `(truck_id)`
- `idx_shipments_source` on `(source_location_id)`
- `idx_shipments_destination` on `(destination_location_id)`
- `idx_shipments_created_by` on `(created_by_id)`
- `idx_shipments_discarded_at` on `(discarded_at)`
- `idx_shipments_type_status_date` on `(shipment_type, status, shipment_date)` — for reports

---

## Table: `shipment_items`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| shipment_id | bigint | NOT NULL, FK → shipments(id) | |
| product_id | bigint | NOT NULL, FK → products(id) | |
| quantity | decimal(12,2) | NOT NULL | |
| weight | decimal(12,2) | | In kg |
| unit | varchar | NOT NULL | kg, ton, piece, bag, liter |
| remarks | text | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_shipment_items_shipment` on `(shipment_id)`
- `idx_shipment_items_product` on `(product_id)`

---

## Table: `shipment_status_logs`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| shipment_id | bigint | NOT NULL, FK → shipments(id) | |
| status | varchar | NOT NULL | |
| changed_by_id | bigint | NOT NULL, FK → users(id) | |
| changed_at | timestamptz | NOT NULL, DEFAULT NOW() | |
| remarks | text | | Optional reason for change |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_status_logs_shipment` on `(shipment_id)`
- `idx_status_logs_changed_at` on `(changed_at)`
- `idx_status_logs_shipment_time` on `(shipment_id, changed_at)`

---

## Table: `notifications`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| user_id | bigint | NOT NULL, FK → users(id) | Recipient |
| type | varchar | NOT NULL | shipment_completed, driver_changed, truck_assigned, export_created |
| title | varchar | NOT NULL | Short title |
| message | text | | Full message |
| read | boolean | DEFAULT false | |
| read_at | timestamptz | | |
| notifiable_type | varchar | | Polymorphic: Shipment, DriverAssignment, etc. |
| notifiable_id | bigint | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_notifications_user` on `(user_id)`
- `idx_notifications_user_read` on `(user_id, read)`
- `idx_notifications_notifiable` on `(notifiable_type, notifiable_id)`

---

## Table: `audit_logs`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| user_id | bigint | FK → users(id) | NULL = system action |
| action | varchar | NOT NULL | create, update, delete |
| auditable_type | varchar | NOT NULL | Model name |
| auditable_id | bigint | NOT NULL | Record ID |
| changes | jsonb | | Before/after values |
| ip_address | inet | | |
| user_agent | varchar | | |
| created_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_audit_logs_auditable` on `(auditable_type, auditable_id)`
- `idx_audit_logs_user` on `(user_id)`
- `idx_audit_logs_action` on `(action)`
- `idx_audit_logs_created_at` on `(created_at)`

---

## Table: `settings`

| Column | Type | Constraints | Notes |
|--------|------|-------------|-------|
| id | bigint | PK, auto-increment | |
| key | varchar | NOT NULL, UNIQUE | e.g., company_name, default_currency |
| value | text | | |
| setting_type | varchar | DEFAULT 'string' | string, integer, boolean, json, text |
| group | varchar | | company, general, notification, status |
| description | text | | |
| created_at | timestamptz | NOT NULL | |
| updated_at | timestamptz | NOT NULL | |

**Indexes:**
- `idx_settings_key` UNIQUE on `(key)`
- `idx_settings_group` on `(group)`

---

## Schema Summary

| # | Table | Type | Soft Delete | Key Relationships |
|---|-------|------|-------------|-------------------|
| 1 | `roles` | Reference | No | Has many users |
| 2 | `users` | Core | Yes | Belongs to role |
| 3 | `locations` | Reference | Yes | Has many routes (from/to) |
| 4 | `routes` | Reference | Yes | Belongs to locations |
| 5 | `trucks` | Core | Yes | Has many driver_assignments, shipments, location_logs |
| 6 | `truck_location_logs` | Log | No | Belongs to truck |
| 7 | `drivers` | Core | Yes | Has many driver_assignments |
| 8 | `driver_assignments` | Transaction | No | Belongs to driver, truck, user |
| 9 | `product_categories` | Reference | Yes | Has many products |
| 10 | `products` | Reference | Yes | Belongs to category |
| 11 | `shipments` | Core | Yes | Belongs to truck, locations, user |
| 12 | `shipment_items` | Transaction | No | Belongs to shipment, product |
| 13 | `shipment_status_logs` | Log | No | Belongs to shipment, user |
| 14 | `notifications` | Transaction | No | Belongs to user (polymorphic) |
| 15 | `audit_logs` | Log | No | Belongs to user (optional) |
| 16 | `settings` | Configuration | No | — |

---

## Naming Conventions

| Convention | Rule | Example |
|------------|------|---------|
| Table names | Plural snake_case | `shipment_items` |
| Primary Key | `id` (bigint) | `id` |
| Foreign Keys | `singular_id` | `shipment_id` |
| Timestamps | `created_at`, `updated_at` | |
| Soft Delete | `discarded_at` (timestamptz) | |
| Enums | varchar with DB check | Rails `enum` in model |
| Indexes | `idx_tablename_column` | `idx_shipments_status` |

---

## Rails Migration & Model Plan

All migrations to include `discarded_at` for soft-deletable tables. Models to use:
- `enum status: { ... }` for status fields
- `belongs_to :role`, `has_many :shipments`, etc.
- `discard` gem for soft delete
- `has_paper_trail` or custom AuditLog for auditing
