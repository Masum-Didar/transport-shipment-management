# 🚛 Transport & Shipment Management System — Work Plan

## 📋 Project Overview

একটি Web-Based Management System যা কোম্পানির Import/Export ট্র্যাকিং, Truck ও Driver Management, Shipment Tracking, এবং Reporting — সবকিছু এক জায়গায় করবে। বর্তমান WhatsApp + Excel Sheet-এর ম্যানুয়াল সিস্টেমকে সম্পূর্ণ ডিজিটাল করা হবে।

**Tech Stack:** Rails 8 + PostgreSQL + Hotwire (Turbo + Stimulus) + Tailwind CSS + Devise + Pundit

---

## 📌 Phase 1: Requirement Analysis (1-2 Days)

- [ ] বর্তমান Business Process ও WhatsApp Workflow বিশ্লেষণ
- [ ] Excel Report সংগ্রহ ও পর্যালোচনা
- [ ] Required Modules চূড়ান্ত করা
- [ ] **Deliverable:** Business Requirement Document (BRD), Feature List

---

## 📌 Phase 2: System Design (2 Days)

### Database Models (Finalized)

| Model | Details |
|-------|---------|
| `User` | Super Admin, Admin, Dispatcher, Operator, Account, Viewer |
| `Role` | Role-based access control |
| `Truck` | truck_number, type (company/outside), status (available/assigned/loading/on_route/maintenance/inactive), current_location_id |
| `TruckLocationLog` | truck_id, location, timestamp, updated_by |
| `Driver` | name, mobile, status (available/driving/leave/inactive) |
| `DriverAssignment` | driver_id, truck_id, assigned_by, assigned_at, released_at |
| `Location` | name, address (Dhaka ICD, Chittagong Port, Benapole, etc.) |
| `Route` | from_location_id, to_location_id, distance, details |
| `Product` | name, category_id, unit |
| `ProductCategory` | name |
| `Shipment` | shipment_type (import/export), source_location_id, dest_location_id, route_id, status (enum: pending/loading/loaded/on_the_way/reached/unloading/completed), shipment_date |
| `ShipmentItem` | shipment_id, product_id, quantity, weight, unit, remarks |
| `ShipmentStatusLog` | shipment_id, status, changed_by, changed_at, remarks |
| `Notification` | user_id, type, message, read, shipment_id |
| `AuditLog` | user_id, action, auditable_type, auditable_id, changes, created_at |
| `Setting` | key, value (company info, vehicle types, etc.) |

**Key Design Decisions:**
- Shipment Status → **Enum** on Shipment model (not separate table) + `shipment_status_logs` for history
- Import/Export → **Single Shipment table** with `shipment_type` enum
- Location → **Separate `locations` table** (not hardcoded source/destination)
- Truck Location → `current_location_id` + `truck_location_logs` for history
- Weight/Quantity → Store on `ShipmentItem` (not Product), since same product can have different qty per shipment
- Soft Delete → Use `deleted_at` or `discard` gem for all major models

### UI Screens

- [ ] Login
- [ ] Dashboard (Live with Turbo Streams)
- [ ] Truck Management
- [ ] Driver Management
- [ ] Product Management
- [ ] Shipment Management (with Timeline UI)
- [ ] Reports
- [ ] Settings

**Deliverable:** ER Diagram, Database Schema, UI Wireframe

---

## 📌 Phase 3: Project Setup (1 Day)

- [ ] Rails 8 new project with PostgreSQL
- [ ] Tailwind CSS setup
- [ ] Hotwire (Turbo + Stimulus) setup
- [ ] Devise authentication setup
- [ ] Pundit authorization setup
- [ ] Active Storage setup
- [ ] Solid Queue setup (background jobs)
- [ ] Git repository initialization
- [ ] Seed data for roles, locations, etc.

---

## 📌 Phase 4: Core Module Development (10-14 Days)

### Module 1: Authentication & Authorization
- [ ] Login / Logout / Forgot Password
- [ ] User Roles: Super Admin, Admin, Dispatcher, Operator, Account, Viewer
- [ ] Profile Management
- [ ] Pundit policies for each role

### Module 2: Dashboard (Live)
- [ ] Today's Export/Import count
- [ ] Active Trucks, Loading, On The Way, Reached
- [ ] Completed vs Pending Shipments
- [ ] Completed %, Average Delivery Time, Delayed Shipments
- [ ] Truck & Driver Utilization %
- [ ] Top Products & Top Routes
- [ ] **Hotwire Turbo Stream** for auto-refresh (no page reload)

### Module 3: Truck Management
- [ ] CRUD with Soft Delete
- [ ] Company Truck vs External Truck
- [ ] Truck Status: Available, Assigned, Loading, On Route, Maintenance, Inactive
- [ ] Current Location (from locations table)
- [ ] Truck Location Log (history)

### Module 4: Driver Management
- [ ] CRUD with Soft Delete
- [ ] Assign/Change Driver to Truck
- [ ] Driver History (via DriverAssignment)
- [ ] Driver Status: Available, Driving, Leave, Inactive

### Module 5: Product Management
- [ ] CRUD with Soft Delete
- [ ] Product Categories
- [ ] Unit management

### Module 6: Shipment Management
- [ ] Create Shipment (Import/Export)
- [ ] Assign Truck & Driver
- [ ] Add Products (ShipmentItems with quantity/weight)
- [ ] Shipment Status Update (enum: pending → loading → loaded → on_the_way → reached → unloading → completed)
- [ ] Shipment Timeline UI (vertical timeline showing each status change)
- [ ] Shipment Status Log (automatic audit)
- [ ] Remarks/Notes

### Module 7: Locations & Routes
- [ ] Location CRUD (Dhaka ICD, Chittagong Port, Benapole, etc.)
- [ ] Route CRUD (from_location → to_location)
- [ ] Source/Destination selection in Shipment from locations

### Module 8: Reports
- [ ] Daily / Weekly / Monthly Report
- [ ] Truck Wise Report
- [ ] Driver Wise Report
- [ ] Product Wise Report
- [ ] Export: PDF (prawn/wicked_pdf), Excel (caxlsx), CSV
- [ ] Print support

### Module 9: Service Objects
- [ ] `Shipments::CreateService`
- [ ] `Shipments::AssignDriverService`
- [ ] `Shipments::UpdateStatusService`
- [ ] `Trucks::AssignService`
- [ ] `Reports::DailyReportService`
- [ ] Query objects for filtering/searching

### Module 10: Notifications (MVP)
- [ ] Shipment Completed notification
- [ ] Driver Changed notification
- [ ] Truck Assigned notification
- [ ] Solid Queue background jobs

### Module 11: Audit Log
- [ ] Track who changed what (user, action, auditable, changes, timestamp)
- [ ] Critical for accountability

### Module 12: Settings
- [ ] Company Information
- [ ] Branch Management
- [ ] Location Management
- [ ] Vehicle Types
- [ ] Product Units
- [ ] Status Configuration

---

## 📌 Phase 5: Testing (2 Days)

- [ ] Functional Testing (all CRUD operations)
- [ ] Validation Testing (form validations, edge cases)
- [ ] Role-based Access Testing
- [ ] Report Generation Testing
- [ ] User Acceptance Testing (UAT)
- [ ] Bug Fixing

---

## 📌 Phase 6: Deployment (1 Day)

- [ ] Production Server Setup
- [ ] Database Migration
- [ ] Environment Configuration (.env)
- [ ] Initial Data Import (Excel to DB seed)
- [ ] Admin Account Setup
- [ ] User Training & Handover

---

## 🎯 Estimated Timeline

| Phase | Duration |
|-------|----------|
| Requirement Analysis | 1-2 Days |
| System Design | 2 Days |
| Project Setup | 1 Day |
| Core Module Development | 10-14 Days |
| Testing | 2 Days |
| Deployment | 1 Day |
| **Total** | **17-22 Working Days** |

---

## 🏗 Architecture (Rails 8)

```
app/
 ├── controllers/
 ├── models/
 ├── services/        # Business logic
 │   ├── shipments/
 │   ├── trucks/
 │   └── reports/
 ├── queries/         # Query objects for filtering/reporting
 ├── policies/        # Pundit authorization
 ├── presenters/      # View presentation logic
 ├── jobs/            # Solid Queue background jobs
 ├── mailers/
 ├── notifications/
 ├── components/      # View components
 └── views/
```

## 🧩 Recommended Gems

| Purpose | Gem |
|---------|-----|
| Authentication | devise |
| Authorization | pundit |
| Search | ransack |
| Pagination | pagy |
| PDF Export | prawn / wicked_pdf |
| Excel Export | caxlsx |
| CSV Export | Built-in Ruby CSV |
| Background Jobs | solid_queue |
| Soft Delete | discard |

---

## 🚀 Future Enhancements (Post-MVP)

- GPS Live Tracking + Google Maps Integration
- Driver Mobile App
- Fuel Management & Vehicle Maintenance
- Expense Tracking
- WhatsApp / SMS / Email Notifications
- Customer Portal
