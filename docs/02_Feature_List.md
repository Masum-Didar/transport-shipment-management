# Feature List
## Transport & Shipment Management System

**Priority Legend:** P1 = Must Have (MVP), P2 = Nice to Have, P3 = Future

---

## 🚛 Module 1: Authentication & Authorization

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 1.1 | User Login (email + password) | **P1** | Devise gem |
| 1.2 | User Logout | **P1** | |
| 1.3 | Forgot Password | **P1** | Devise built-in |
| 1.4 | User Registration (Admin only) | **P1** | No public registration |
| 1.5 | Role Management (6 roles) | **P1** | Super Admin, Admin, Dispatcher, Operator, Account, Viewer |
| 1.6 | Role-based Access Control | **P1** | Pundit policies |
| 1.7 | Profile Edit | P2 | Name, password change |

---

## 📊 Module 2: Dashboard

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 2.1 | Today's Export Count | **P1** | |
| 2.2 | Today's Import Count | **P1** | |
| 2.3 | Active (On Route) Trucks Count | **P1** | |
| 2.4 | Loading Trucks Count | **P1** | |
| 2.5 | Reached / Completed Count | **P1** | |
| 2.6 | Pending Shipments Count | P2 | |
| 2.7 | Completed Shipments % | P2 | |
| 2.8 | Average Delivery Time | P2 | |
| 2.9 | Delayed Shipments | P2 | |
| 2.10 | Truck Utilization % | P2 | |
| 2.11 | Driver Utilization % | P2 | |
| 2.12 | Top Products (This Month) | P2 | |
| 2.13 | Top Routes (This Month) | P2 | |
| 2.14 | Turbo Stream Auto-Refresh | **P1** | Live updates without page reload |

---

## 🚛 Module 3: Truck Management

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 3.1 | Add New Truck | **P1** | Number, type, status |
| 3.2 | Edit Truck | **P1** | |
| 3.3 | Soft Delete Truck | **P1** | Using `discard` gem |
| 3.4 | Truck Type: Company/Outside | **P1** | Dropdown |
| 3.5 | Truck Status: Available, Assigned, Loading, On Route, Maintenance, Inactive | **P1** | |
| 3.6 | Current Location (from Locations) | **P1** | |
| 3.7 | Truck List with Filters | **P1** | By status, type |
| 3.8 | Truck Detail Page | **P1** | Show current driver, current shipment |
| 3.9 | Truck Location History Log | P2 | `truck_location_logs` table |

---

## 👨‍✈️ Module 4: Driver Management

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 4.1 | Add New Driver | **P1** | Name, mobile, status |
| 4.2 | Edit Driver | **P1** | |
| 4.3 | Soft Delete Driver | **P1** | |
| 4.4 | Assign Driver to Truck | **P1** | |
| 4.5 | Change Driver (with history) | **P1** | `driver_assignments` table |
| 4.6 | Driver Status: Available, Driving, Leave, Inactive | **P1** | |
| 4.7 | Driver List with Filters | **P1** | By status, truck |
| 4.8 | Driver Assignment History | P2 | Timeline of assignments |

---

## 📦 Module 5: Product Management

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 5.1 | Add Product | **P1** | Name, category, unit |
| 5.2 | Edit Product | **P1** | |
| 5.3 | Soft Delete Product | **P1** | |
| 5.4 | Product Category CRUD | **P1** | |
| 5.5 | Product Unit Configuration | P2 | kg, ton, piece, etc. |

---

## 📍 Module 6: Location & Route Management

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 6.1 | Add Location | **P1** | Dhaka ICD, Chittagong Port, Benapole, etc. |
| 6.2 | Edit / Delete Location | **P1** | |
| 6.3 | Add Route (from → to) | **P1** | |
| 6.4 | Edit / Delete Route | **P1** | |

---

## 📋 Module 7: Shipment Management

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 7.1 | Create Shipment (Import/Export) | **P1** | `shipment_type` enum |
| 7.2 | Auto-generate Shipment ID/Number | **P1** | e.g., SH-2026-0001 |
| 7.3 | Select Source & Destination (from Locations) | **P1** | |
| 7.4 | Select Route | **P1** | |
| 7.5 | Assign Truck | **P1** | From available trucks |
| 7.6 | Assign Driver | **P1** | From available drivers |
| 7.7 | Add Products (multiple) with Quantity & Weight | **P1** | `shipment_items` table |
| 7.8 | Shipment Status Update | **P1** | Pending → Loading → Loaded → On The Way → Reached → Unloading → Completed |
| 7.9 | Shipment Timeline View | **P1** | Vertical timeline UI |
| 7.10 | Shipment Status Log (auto) | **P1** | `shipment_status_logs` table |
| 7.11 | Add Remarks / Notes | P2 | |
| 7.12 | Shipment List with Filters | **P1** | By type, status, date |
| 7.13 | Shipment Detail Page | **P1** | Full info with timeline |

---

## 📑 Module 8: Reports

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 8.1 | Daily Report | **P1** | Date-wise filter |
| 8.2 | Weekly Report | **P1** | Week-wise filter |
| 8.3 | Monthly Report | **P1** | Month-wise filter |
| 8.4 | Truck Wise Report | **P1** | Per truck summary |
| 8.5 | Driver Wise Report | **P1** | Per driver summary |
| 8.6 | Product Wise Report | P2 | Per product summary |
| 8.7 | Export to PDF | **P1** | prawn / wicked_pdf |
| 8.8 | Export to Excel | **P1** | caxlsx gem |
| 8.9 | Export to CSV | **P1** | Ruby built-in CSV |
| 8.10 | Print Report | **P1** | Print-friendly CSS |

---

## 🔔 Module 9: Notifications

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 9.1 | Shipment Completed Notification | P2 | Solid Queue background job |
| 9.2 | Driver Changed Notification | P2 | |
| 9.3 | Truck Assigned Notification | P2 | |
| 9.4 | Export Created Notification | P2 | |
| 9.5 | Notification Bell (UI) | P2 | Unread count badge |

---

## 📝 Module 10: Audit Log

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 10.1 | Auto-log all CRUD operations | **P1** | user, action, auditable, changes, timestamp |
| 10.2 | Audit Log View (Admin) | P2 | Filterable list |

---

## ⚙️ Module 11: Settings

| # | Feature | Priority | Notes |
|---|---------|----------|-------|
| 11.1 | Company Information (name, address, phone, etc.) | P2 | |
| 11.2 | Branch Management | P2 | |
| 11.3 | Vehicle Types Configuration | P2 | |
| 11.4 | Product Units Configuration | P2 | kg, ton, piece, bag, etc. |
| 11.5 | Shipment Status Configuration | P2 | |
| 11.6 | Truck / Driver Status Configuration | P2 | |

---

## 📊 Feature Summary

| Module | P1 | P2 | Total |
|--------|----|----|-------|
| Auth & Authorization | 6 | 1 | 7 |
| Dashboard | 4 | 10 | 14 |
| Truck Management | 8 | 1 | 9 |
| Driver Management | 7 | 1 | 8 |
| Product Management | 4 | 1 | 5 |
| Location & Route | 4 | 0 | 4 |
| Shipment Management | 12 | 1 | 13 |
| Reports | 9 | 1 | 10 |
| Notifications | 0 | 5 | 5 |
| Audit Log | 1 | 1 | 2 |
| Settings | 0 | 6 | 6 |
| **Total** | **55** | **28** | **83** |
