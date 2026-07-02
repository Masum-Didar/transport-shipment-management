# Business Requirement Document (BRD)
## Transport & Shipment Management System

---

## 1. Executive Summary

বর্তমানে কোম্পানির Import ও Export-সংক্রান্ত সকল কার্যক্রম **WhatsApp Group** এবং **Excel Sheet**-এর মাধ্যমে পরিচালিত হচ্ছে। প্রতিদিন কোন ট্রাক কোথায় যাচ্ছে, কোন পণ্য বহন করছে, কোন ট্রাক গন্তব্যে পৌঁছেছে — এসব তথ্য ম্যানুয়ালি আপডেট করতে হয়। এই ম্যানুয়াল সিস্টেমে তথ্য হারানোর ঝুঁকি, সময়ক্ষেপণ, এবং ভুল হওয়ার সম্ভাবনা রয়েছে।

একটি **Web-Based Transport & Shipment Management System** উন্নয়ন করা হবে যা সমস্ত কার্যক্রমকে ডিজিটালাইজ করবে, তথ্য সংরক্ষণ ও ট্র্যাকিং সহজ করবে, এবং রিপোর্টিং স্বয়ংক্রিয় করবে।

---

## 2. Business Context

| Aspect | Detail |
|--------|--------|
| **Company** | Transport & Import-Export কোম্পানি |
| **Current System** | WhatsApp Group + Excel Sheets (Manual) |
| **Problem** | তথ্য ছড়িয়ে-ছিটিয়ে আছে, ট্র্যাকিং কঠিন, রিপোর্ট তৈরি সময়সাপেক্ষ, manual error বেশি |
| **Solution** | Web-Based Management System (Rails 8 + PostgreSQL) |
| **Target Users** | Admin, Dispatcher, Operator, Accountant, Viewer |

---

## 3. Objectives

1. Import ও Export-এর সকল তথ্য এক কেন্দ্রীয় জায়গায় সংরক্ষণ করা
2. প্রতিটি ট্রাকের বর্তমান অবস্থা (Live Status)实时 দেখা
3. কোন ট্রাকে কোন পণ্য যাচ্ছে তা সহজে ট্র্যাক করা
4. Daily, Weekly ও Monthly Report এক ক্লিকে তৈরি করা
5. WhatsApp-এর পরিবর্তে একটি কেন্দ্রীয় সিস্টেম ব্যবহার করা
6. Manual ভুল কমানো ও কাজের গতি বাড়ানো

---

## 4. Scope

### In Scope (MVP)

- **Truck Management:** ট্রাক সংযোজন, সম্পাদনা, স্টatus ট্র্যাকিং
- **Driver Management:** ড্রাইভার সংযোজন, অ্যাসাইনমেন্ট, ইতিহাস
- **Shipment Management:** Import/Export Shipment তৈরি, স্টatus আপডেট, টাইমলাইন
- **Product Management:** পণ্য ও ক্যাটাগরি ব্যবস্থাপনা
- **Location & Route Management:** লোকেশন ও রুট ব্যবস্থাপনা
- **Dashboard:** লাইভ ড্যাশবোর্ড (Turbo Streams দিয়ে auto-refresh)
- **Reports:** Daily, Weekly, Monthly, Truck Wise, Driver Wise, Product Wise (PDF/Excel/CSV)
- **User Management:** Role-based authentication (Super Admin, Admin, Dispatcher, Operator, Account, Viewer)
- **Audit Log:** সকল পরিবর্তনের লগ
- **Notifications:** Shipment, Driver, Truck সংক্রান্ত নোটিফিকেশন

### Out of Scope (Post-MVP)

- GPS Live Tracking
- Google Maps Integration
- Driver Mobile App
- Fuel Management
- Vehicle Maintenance
- Expense Tracking
- WhatsApp/SMS/Email Notification Integration
- Customer Portal

---

## 5. Stakeholders

| Stakeholder | Role | Needs |
|-------------|------|-------|
| **Super Admin** | System owner | Full access, user management, audit logs |
| **Admin** | Operations head | All operations, reports, settings |
| **Dispatcher** | Day-to-day operations | Shipment create/update, truck/driver assign |
| **Operator** | Data entry | Shipment entry, status update |
| **Accountant** | Billing/reporting | Reports, shipment history |
| **Viewer** | Management | Read-only dashboard & reports |

---

## 6. Functional Requirements

### FR-01: Authentication & Authorization
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-01.1 | Users can login with email & password | P1 |
| FR-01.2 | Users can reset forgotten password | P1 |
| FR-01.3 | System supports 6 roles: Super Admin, Admin, Dispatcher, Operator, Account, Viewer | P1 |
| FR-01.4 | Each role has specific permissions (Pundit policies) | P1 |
| FR-01.5 | Users can update their profile | P2 |

### FR-02: Dashboard
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-02.1 | Show Today's Export count | P1 |
| FR-02.2 | Show Today's Import count | P1 |
| FR-02.3 | Show Active Trucks count | P1 |
| FR-02.4 | Show Loading / On The Way / Reached / Completed shipment counts | P1 |
| FR-02.5 | Show Pending Shipments | P2 |
| FR-02.6 | Show Completed %, Average Delivery Time, Delayed Shipments | P2 |
| FR-02.7 | Show Truck & Driver Utilization % | P2 |
| FR-02.8 | Show Top Products & Top Routes | P2 |
| FR-02.9 | Dashboard auto-refreshes with Turbo Streams | P1 |

### FR-03: Truck Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-03.1 | Add new truck (number, type, status) | P1 |
| FR-03.2 | Edit truck details | P1 |
| FR-03.3 | Soft delete truck | P1 |
| FR-03.4 | Truck type: Company / Outside | P1 |
| FR-03.5 | Truck status: Available, Assigned, Loading, On Route, Maintenance, Inactive | P1 |
| FR-03.6 | Track current location | P1 |
| FR-03.7 | View truck location history | P2 |

### FR-04: Driver Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-04.1 | Add new driver (name, mobile) | P1 |
| FR-04.2 | Edit driver details | P1 |
| FR-04.3 | Soft delete driver | P1 |
| FR-04.4 | Assign driver to truck | P1 |
| FR-04.5 | Change driver (with history) | P1 |
| FR-04.6 | Driver status: Available, Driving, Leave, Inactive | P1 |
| FR-04.7 | View driver assignment history | P2 |

### FR-05: Product Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-05.1 | Add product (name, category, unit) | P1 |
| FR-05.2 | Edit/Delete product | P1 |
| FR-05.3 | Product categories CRUD | P1 |
| FR-05.4 | Soft delete for products | P1 |

### FR-06: Location & Route Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-06.1 | Add location (e.g., Dhaka ICD, Chittagong Port, Benapole) | P1 |
| FR-06.2 | Create route (from_location → to_location) | P1 |
| FR-06.3 | Edit/Delete locations & routes | P1 |

### FR-07: Shipment Management
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-07.1 | Create shipment (type: Import/Export) | P1 |
| FR-07.2 | Assign truck to shipment | P1 |
| FR-07.3 | Assign driver to shipment | P1 |
| FR-07.4 | Add products with quantity & weight | P1 |
| FR-07.5 | Update shipment status (Pending → Loading → Loaded → On The Way → Reached → Unloading → Completed) | P1 |
| FR-07.6 | View shipment timeline | P1 |
| FR-07.7 | Add remarks to shipment | P2 |
| FR-07.8 | View shipment history (status logs) | P1 |

### FR-08: Reports
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-08.1 | Daily Report | P1 |
| FR-08.2 | Weekly Report | P1 |
| FR-08.3 | Monthly Report | P1 |
| FR-08.4 | Truck Wise Report | P1 |
| FR-08.5 | Driver Wise Report | P1 |
| FR-08.6 | Product Wise Report | P2 |
| FR-08.7 | Export to PDF | P1 |
| FR-08.8 | Export to Excel | P1 |
| FR-08.9 | Export to CSV | P1 |
| FR-08.10 | Print report | P1 |

### FR-09: Notifications
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-09.1 | Shipment Completed notification | P2 |
| FR-09.2 | Driver Changed notification | P2 |
| FR-09.3 | Truck Assigned notification | P2 |
| FR-09.4 | Export Created notification | P2 |

### FR-10: Audit Log
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-10.1 | Log all create/update/delete operations | P1 |
| FR-10.2 | Store: user, action, auditable type/id, changes, timestamp | P1 |
| FR-10.3 | Admin can view audit logs | P2 |

### FR-11: Settings
| ID | Requirement | Priority |
|----|-------------|----------|
| FR-11.1 | Company Information settings | P2 |
| FR-11.2 | Branch Management | P2 |
| FR-11.3 | Vehicle Types configuration | P2 |
| FR-11.4 | Product Units configuration | P2 |
| FR-11.5 | Status configuration | P2 |

---

## 7. Non-Functional Requirements

| NFR | Detail |
|-----|--------|
| **Performance** | Pages should load within 2 seconds |
| **Security** | Role-based access, password encryption (Devise) |
| **Reliability** | Data integrity with PostgreSQL constraints |
| **Usability** | Bengali-friendly UI, simple & clean interface |
| **Scalability** | Solid Queue for background jobs, pagination with Pagy |
| **Maintainability** | Service Objects, Query Objects, clean architecture |
| **Availability** | Web-based, accessible from any device with internet |

---

## 8. Assumptions & Constraints

- Users have basic computer & internet literacy
- Initial data (trucks, drivers, products) will be migrated from existing Excel sheets
- System will be deployed on a Linux server
- No GPS hardware integration in MVP
- All users are internal (no public registration)

---

## 9. Success Criteria

- ✅ সকল Import/Export তথ্য সিস্টেমে সংরক্ষিত হচ্ছে
- ✅ প্রতিটি ট্রাকের বর্তমান স্টatus ১ ক্লিকে দেখা যাচ্ছে
- ✅ Daily/Weekly/Monthly Report ১ ক্লিকে তৈরি হচ্ছে
- ✅ WhatsApp-এ তথ্য খোঁজার প্রয়োজন কমেছে
- ✅ Manual Error কমেছে
- ✅ ব্যবহারকারীরা সিস্টেম ব্যবহারে স্বাচ্ছন্দ্য বোধ করছেন

---

## 10. Glossary

| Term | Meaning |
|------|---------|
| **Shipment** | Import বা Export পণ্য পরিবহনের একটি ইউনিট |
| **Import** | দেশের বাইরে থেকে পণ্য আনা |
| **Export** | দেশের বাইরে পণ্য পাঠানো |
| **Dispatcher** | যিনি প্রতিদিনের ট্রাক ও ড্রাইভার ব্যবস্থাপনা করেন |
| **Operator** | যিনি ডাটা এন্ট্রি করেন |
| **Audit Log** | কে কী পরিবর্তন করেছে তার রেকর্ড |
| **Soft Delete** | ডাটা না মুছে deleted_at flag দেওয়া |
