# UI Wireframe
## Transport & Shipment Management System — Hotwire + Tailwind CSS

**Design Principles:**
- Mobile-first responsive layout
- Bengali-friendly (Unicode supported)
- Minimal, clean, functional
- Same sidebar navigation across all pages
- Turbo Drive for fast page loads
- Turbo Streams for live updates

---

## 1. Global Layout

```
┌─────────────────────────────────────────────────────┐
│  📦 TSM System                    🔔 👤 John Doe   │  ← Top Navbar
├──────────┬──────────────────────────────────────────┤
│          │                                          │
│ 🏠 Dashboard │  Welcome back, John!                │
│ 🚛 Trucks    │                                      │
│ 👨‍✈️ Drivers   │  [ MAIN CONTENT AREA ]              │
│ 📦 Products  │                                      │
│ 📋 Shipments │                                      │
│ 📍 Locations │                                      │
│ 🗺️ Routes    │                                      │
│ 📊 Reports   │                                      │
│ ⚙️ Settings  │                                      │
│          │                                          │
├──────────┴──────────────────────────────────────────┤
│  © 2026 TSM System                        v1.0.0   │  ← Footer
└─────────────────────────────────────────────────────┘
```

**Sidebar Navigation:**
| Icon | Item | Roles |
|------|------|-------|
| 🏠 | Dashboard | All |
| 🚛 | Trucks | Admin, Dispatcher, Operator |
| 👨‍✈️ | Drivers | Admin, Dispatcher, Operator |
| 📦 | Products | Admin, Dispatcher, Operator |
| 📋 | Shipments | Admin, Dispatcher, Operator |
| 📍 | Locations | Admin, Dispatcher |
| 🗺️ | Routes | Admin, Dispatcher |
| 📊 | Reports | Admin, Dispatcher, Account |
| 📝 | Audit Log | Super Admin, Admin |
| ⚙️ | Settings | Super Admin, Admin |

---

## 2. Login Page

```
┌────────────────────────────────────┐
│                                    │
│        📦 TSM SYSTEM              │
│                                    │
│   ┌──────────────────────────┐    │
│   │  Email                   │    │
│   └──────────────────────────┘    │
│                                    │
│   ┌──────────────────────────┐    │
│   │  Password                │    │
│   └──────────────────────────┘    │
│                                    │
│   ┌──────────────────────────┐    │
│   │      🔐 Sign In          │    │
│   └──────────────────────────┘    │
│                                    │
│   Forgot Password?                │
│                                    │
└────────────────────────────────────┘
```

---

## 3. Dashboard Page

```
┌──────────────────────────────────────────────────────────┐
│ 🏠 Dashboard                                    [Today] │
├────────────┬────────────┬────────────┬───────────────────┤
│ 📤 Export  │ 📥 Import  │ 🚛 Active  │ ✅ Completed      │
│    12     │     8      │    15     │     18            │
│  Today    │   Today    │   Trucks  │   Shipments       │
├────────────┴────────────┴────────────┴───────────────────┤
│ ┌──────────────┐ ┌──────────────┐ ┌──────────────────┐  │
│ │  🔄 Loading  │ │  🚗 On Way   │ │  📋 Pending      │  │
│ │      5       │ │     10      │ │       7          │  │
│ └──────────────┘ └──────────────┘ └──────────────────┘  │
├──────────────────────────────────────────────────────────┤
│  📊 Performance                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │ Completed: ████████████░░░░░░░  68%              │   │
│  │ Avg Delivery: ████████░░░░░░░░░  2.5 days        │   │
│  │ Delayed: ██░░░░░░░░░░░░░░░░░░  3 shipments      │   │
│  └──────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────┤
│  📦 Recent Shipments                          [View All]│
│  ┌──────┬──────────┬────────┬────────┬──────────────┐   │
│  │ #    │ Type     │ Truck  │ Status │ Date         │   │
│  ├──────┼──────────┼────────┼────────┼──────────────┤   │
│  │ 0024 │ Export   │ D-1234 │ 🚗     │ 02 Jul 2026  │   │
│  │ 0023 │ Import   │ D-5678 │ ✅     │ 02 Jul 2026  │   │
│  │ 0022 │ Export   │ D-9012 │ 🔄     │ 01 Jul 2026  │   │
│  │ 0021 │ Import   │ D-3456 │ 🚗     │ 01 Jul 2026  │   │
│  └──────┴──────────┴────────┴────────┴──────────────┘   │
└──────────────────────────────────────────────────────────┘
```

**Live Updates:** Turbo Stream will auto-update counts and recent shipments every 30 seconds — no page reload needed.

---

## 4. Truck Management — List Page

```
┌──────────────────────────────────────────────────────────┐
│ 🚛 Trucks                                    [+ Add New] │
├──────────────────────────────────────────────────────────┤
│ Search: [_______________]  Status: [All ▼]  Type: [All] │
├──────┬──────────┬──────────┬────────┬────────┬──────────┤
│ #    │ Number   │ Type     │ Status │ Driver │ Action   │
├──────┼──────────┼──────────┼────────┼────────┼──────────┤
│ 1    │ D-1234   │ Company  │ 🟢 Avail│ Karim  │ 👁 ✏️ 🗑 │
│ 2    │ D-5678   │ Company  │ 🟡 Assgn│ Rahim  │ 👁 ✏️ 🗑 │
│ 3    │ D-9012   │ Outside  │ 🔴 Maint│ —      │ 👁 ✏️ 🗑 │
│ 4    │ D-3456   │ Company  │ 🟢 Avail│ —      │ 👁 ✏️ 🗑 │
└──────┴──────────┴──────────┴────────┴────────┴──────────┘
                                     [← Prev] [1] [2] [3] [Next →]

Status Legend: 🟢 Available  🟡 Assigned  🔵 Loading  🚗 On Route  🔴 Maintenance ⚫ Inactive
```

### Truck Form (Modal/Drawer)

```
┌──────────────────────────────────┐
│ 🚛 Add New Truck                 │
├──────────────────────────────────┤
│ Truck Number  [________________] │
│ Truck Type    [Company ▼]        │
│ Brand         [________________] │
│ Model         [________________] │
│ Year          [________]         │
│ Capacity (kg) [________]         │
│ Status        [Available ▼]      │
│ Current Loc   [Select Location ▼]│
│ Notes         [________________] │
│                                  │
│        [Cancel]  [💾 Save]       │
└──────────────────────────────────┘
```

---

## 5. Driver Management — List Page

```
┌──────────────────────────────────────────────────────────┐
│ 👨‍✈️ Drivers                                   [+ Add New] │
├──────────────────────────────────────────────────────────┤
│ Search: [_______________]  Status: [All ▼]              │
├──────┬──────────┬──────────┬──────────┬────────┬────────┤
│ #    │ Name     │ Phone    │ Status   │ Truck  │ Action │
├──────┼──────────┼──────────┼──────────┼────────┼────────┤
│ 1    │ Karim    │ 01xxxx   │ 🟢 Avail  │ —     │ 👁 ✏️ 🗑│
│ 2    │ Rahim    │ 01xxxx   │ 🚗 Driving│ D-5678│ 👁 ✏️ 🗑│
│ 3    │ Hasan    │ 01xxxx   │ 🏖️ Leave  │ —     │ 👁 ✏️ 🗑│
└──────┴──────────┴──────────┴──────────┴────────┴────────┘
```

### Assign Driver Modal

```
┌──────────────────────────────────┐
│ Assign Driver to Truck           │
├──────────────────────────────────┤
│ Driver:  [Karim ▼]              │
│ Truck:   [D-1234 ▼]             │
│ From:    [02 Jul 2026 ▼]        │
│                                  │
│     [Cancel]  [✅ Assign]        │
└──────────────────────────────────┘
```

---

## 6. Shipment Management — List Page

```
┌──────────────────────────────────────────────────────────────────┐
│ 📋 Shipments                                         [+ New Shipment] │
├──────────────────────────────────────────────────────────────────┤
│ Search: [_______]  Type: [All ▼]  Status: [All ▼]  Date: [___] │
├───────┬────────┬──────────┬──────────┬────────┬────────┬────────┤
│ #     │ Number │ Type     │ Truck    │ Status  │ Date   │ Action │
├───────┼────────┼──────────┼──────────┼────────┼────────┼────────┤
│ 1     │SH-0024 │ 📤 Export│ D-1234   │ 🚗 OW   │02 Jul  │ 👁 ✏️  │
│ 2     │SH-0023 │ 📥 Import│ D-5678   │ ✅ Done │02 Jul  │ 👁 ✏️  │
│ 3     │SH-0022 │ 📤 Export│ D-9012   │ 🔄 Load │01 Jul  │ 👁 ✏️  │
│ 4     │SH-0021 │ 📥 Import│ D-3456   │ 🚗 OW   │01 Jul  │ 👁 ✏️  │
└───────┴────────┴──────────┴──────────┴────────┴────────┴────────┘

Status: ⏳ Pending  🔄 Loading  📦 Loaded  🚗 On The Way  📍 Reached  📥 Unloading  ✅ Completed
```

---

## 7. Shipment Create / Edit Form

```
┌─────────────────────────────────────────────────┐
│ 📋 New Shipment                                 │
├─────────────────────────────────────────────────┤
│ Shipment Type   [📤 Export ▼]                   │
│ Source Location [Dhaka ICD ▼]                   │
│ Destination     [Chittagong Port ▼]             │
│ Route           [Dhaka → Ctg Port (264km) ▼]   │
│ Shipment Date   [02 Jul 2026 ▼]                 │
│ Est. Delivery   [05 Jul 2026 ▼]                 │
│                                                  │
│ 🚛 Assign Truck   [D-1234 (Karim) ▼]           │
│ 👨‍✈️ Assign Driver  [Select Driver ▼]            │
│                                                  │
│ 📦 Products                         [+ Add]    │
│ ┌──────┬──────────┬────────┬──────┬─────────┐  │
│ │ #    │ Product  │ Qty    │ Wt   │ Unit    │  │
│ ├──────┼──────────┼────────┼──────┼─────────┤  │
│ │ 1    │ Rice     │ 500    │ 500  │ kg      │  │
│ │ 2    │ Wheat    │ 300    │ 300  │ kg      │  │
│ └──────┴──────────┴────────┴──────┴─────────┘  │
│                                                  │
│ Notes: [________________________________]       │
│                                                  │
│           [Cancel]      [💾 Save Shipment]      │
└─────────────────────────────────────────────────┘
```

---

## 8. Shipment Detail Page (with Timeline)

```
┌─────────────────────────────────────────────────────────────┐
│ 📋 Shipment: SH-2026-0024                    [Edit] [Print]│
├─────────────────────────────────────────────────────────────┤
│ 📤 Export  |  Dhaka ICD → Chittagong Port  |  🚗 On The Way│
├────────────────┬────────────────────────────────────────────┤
│ 📋 Details     │  📅 Timeline                              │
│                │                                            │
│ Type: Export   │  ✅ Completed        02 Jul, 6:00 PM      │
│ Truck: D-1234  │       ↕                                   │
│ Driver: Karim  │  📥 Unloading        02 Jul, 4:00 PM      │
│ Source: Dhaka  │       ↕                                   │
│ Dest: Ctg Port │  📍 Reached          02 Jul, 2:00 PM      │
│ Route: 264km   │       ↕                                   │
│ Date: 02 Jul   │  🚗 On The Way  ← 🟡 NOW  02 Jul, 10:00 AM│
│ Products:      │       ↕                                   │
│  • Rice: 500kg │  📦 Loaded           02 Jul, 8:00 AM      │
│  • Wheat: 300kg│       ↕                                   │
│                │  🔄 Loading          02 Jul, 6:00 AM      │
│                │       ↕                                   │
│ Status Update: │  ⏳ Pending          02 Jul, 6:00 AM      │
│ [🚗 On The Way ▼]                                          │
│ [ Update Status ]                                           │
└────────────────┴────────────────────────────────────────────┘
```

**Timeline Features:**
- Vertical timeline with icons for each status
- Current status highlighted (🟡)
- Timestamp for each status change
- "Update Status" button at bottom for quick change

---

## 9. Reports Page

```
┌──────────────────────────────────────────────────────────┐
│ 📊 Reports                                               │
├──────────────────────────────────────────────────────────┤
│ [📅 Daily] [📅 Weekly] [📅 Monthly] [🚛 Truck] [👤 Driver]│
├──────────────────────────────────────────────────────────┤
│ Date Range: [01 Jul 2026 ▼] to [02 Jul 2026 ▼]          │
│ Type: [All ▼]  Status: [All ▼]                          │
│                                              [🔍 Generate]│
├──────────────────────────────────────────────────────────┤
│ 📊 Report Summary                                        │
├──────────┬──────────┬──────────┬──────────┬──────────────┤
│ Metric   │ Today    │ Week     │ Month    │ Change       │
├──────────┼──────────┼──────────┼──────────┼──────────────┤
│ Export   │ 12       │ 45       │ 180      │ ↑ 12%        │
│ Import   │ 8        │ 32       │ 140      │ ↓ 5%         │
│ Total    │ 20       │ 77       │ 320      │ ↑ 8%         │
│ Completed│ 18       │ 70       │ 290      │ ↑ 10%        │
└──────────┴──────────┴──────────┴──────────┴──────────────┘
│                                                          │
│ [📄 PDF] [📊 Excel] [📃 CSV] [🖨️ Print]                  │
└──────────────────────────────────────────────────────────┘
```

---

## 10. Settings Page

```
┌──────────────────────────────────────────────────────────┐
│ ⚙️ Settings                                              │
├───────┬──────────────────────────────────────────────────┤
│ 🏢    │ Company Information                              │
│       ├──────────────────────────────────────────────────┤
│       │ Company Name  [________________]                │
│       │ Address       [________________]                │
│       │ Phone         [________________]                │
│       │ Email         [________________]                │
│       │                                    [💾 Save]    │
├───────┼──────────────────────────────────────────────────┤
│ 👥    │ User Management                                  │
│       ├──────────────────────────────────────────────────┤
│       │ ┌──────┬──────────┬──────────┬────────┬──────┐  │
│       │ │ Name │ Email    │ Role     │ Status │Action│  │
│       │ ├──────┼──────────┼──────────┼────────┼──────┤  │
│       │ │ John │ j@e.com  │ Admin    │ Active │ ✏️ 🗑│  │
│       │ │ Sara │ s@e.com  │ Operator │ Active │ ✏️ 🗑│  │
│       │ └──────┴──────────┴──────────┴────────┴──────┘  │
│       │                                   [+ Add User]  │
├───────┼──────────────────────────────────────────────────┤
│ 📍    │ Locations & Routes                               │
│ ⚙️    │ Status Configuration                             │
└───────┴──────────────────────────────────────────────────┘
```

---

## 11. Mobile Responsive Layout

```
┌──────────────┐    ┌──────────────────┐
│  ☰  📦 TSM   │    │  ← Shipments    │
├──────────────┤    ├──────────────────┤
│              │    │ SH-0024          │
│ [Main        │    │ Export           │
│  Content     │    │ Dhaka → Ctg     │
│  Full Width] │    │ 🚗 On The Way   │
│              │    │ 02 Jul 2026     │
│              │    │                  │
│              │    │ [Details...]     │
└──────────────┘    └──────────────────┘
  Mobile Menu         Detail View
  (Sidebar hidden,   (Full width, stacked)
   hamburger menu)
```

**Mobile Behavior:**
- Sidebar hidden by default → hamburger (☰) toggle
- Tables → card layout (stacked) on small screens
- Forms → single column
- Timeline → smaller icons, compact text
- Bottom nav for key actions

---

## 12. Color Palette (Tailwind)

| Element | Color | Tailwind Class | Usage |
|---------|-------|----------------|-------|
| Primary | Blue | `blue-600` | Buttons, links, active states |
| Success | Green | `green-500` | Completed, Available |
| Warning | Yellow | `yellow-500` | Loading, Pending |
| Danger | Red | `red-500` | Delayed, Maintenance |
| Info | Indigo | `indigo-500` | On The Way, Info badges |
| Neutral | Gray | `gray-100/700/900` | Backgrounds, text |
| Sidebar | Dark | `gray-900` | Sidebar background |

**Shipment Status Colors:**
| Status | Color | Badge |
|--------|-------|-------|
| Pending | Yellow | `bg-yellow-100 text-yellow-800` |
| Loading | Blue | `bg-blue-100 text-blue-800` |
| Loaded | Indigo | `bg-indigo-100 text-indigo-800` |
| On The Way | Orange | `bg-orange-100 text-orange-800` |
| Reached | Teal | `bg-teal-100 text-teal-800` |
| Unloading | Purple | `bg-purple-100 text-purple-800` |
| Completed | Green | `bg-green-100 text-green-800` |

---

## 13. Component Tree

```
app/views/
 ├── layouts/
 │   ├── application.html.erb      ← Main layout (navbar + sidebar)
 │   └── auth.html.erb             ← Login layout (minimal)
 ├── dashboard/
 │   └── index.html.erb
 ├── trucks/
 │   ├── index.html.erb            ← List with filters
 │   ├── show.html.erb             ← Detail page
 │   ├── _form.html.erb            ← Partial (create/edit)
 │   └── _truck.html.erb           ← Row partial
 ├── drivers/
 │   ├── index.html.erb
 │   ├── show.html.erb
 │   ├── _form.html.erb
 │   └── _driver.html.erb
 ├── products/
 │   ├── index.html.erb
 │   ├── _form.html.erb
 │   └── _product.html.erb
 ├── shipments/
 │   ├── index.html.erb
 │   ├── show.html.erb             ← With timeline
 │   ├── new.html.erb
 │   ├── edit.html.erb
 │   ├── _form.html.erb
 │   └── _timeline.html.erb        ← Timeline component
 ├── locations/
 │   ├── index.html.erb
 │   └── _form.html.erb
 ├── routes/
 │   ├── index.html.erb
 │   └── _form.html.erb
 ├── reports/
 │   └── index.html.erb
 ├── settings/
 │   ├── index.html.erb
 │   ├── users/
 │   └── company.html.erb
 ├── notifications/
 │   └── _bell.html.erb            ← Notification dropdown
 └── shared/
     ├── _sidebar.html.erb
     ├── _navbar.html.erb
     ├── _flash.html.erb
     ├── _pagination.html.erb
     └── _modal.html.erb           ← Reusable modal component
```

---

## 14. Turbo Stream Channels

| Stream | Source | Target | Trigger |
|--------|--------|--------|---------|
| `dashboard_stats` | Jobs::DashboardStatsJob | Dashboard counts | Every 30s |
| `recent_shipments` | Jobs::RecentShipmentsJob | Recent shipments table | On status change |
| `notification_count` | NotificationsController | Bell icon badge | New notification |
| `shipment_status` | Shipments::UpdateStatusService | Timeline + badge | Status update |
