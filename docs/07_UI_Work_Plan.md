# UI Design & Implementation Plan

## Transport & Shipment Management System

---

## Table of Contents

1. [Design System Foundation](#1-design-system-foundation)
2. [Layout & Navigation](#2-layout--navigation)
3. [Component Library](#3-component-library)
4. [Page-by-Page UI Plan](#4-page-by-page-ui-plan)
5. [Interactive Features (Stimulus + Turbo)](#5-interactive-features)
6. [Bengali Language Support](#6-bengali-language-support)
7. [Responsive Breakpoints](#7-responsive-breakpoints)
8. [Accessibility](#8-accessibility)
9. [Implementation Order](#9-implementation-order)

---

## 1. Design System Foundation

### 1.1 Color Palette

| Token | Tailwind | Hex | Usage |
|-------|----------|-----|-------|
| `primary` | `blue-600` | `#2563EB` | Buttons, links, active states |
| `primary-hover` | `blue-700` | `#1D4ED8` | Button hover |
| `primary-light` | `blue-50` | `#EFF6FF` | Background tints |
| `success` | `green-500` | `#22C55E` | Completed, active |
| `warning` | `yellow-500` | `#EAB308` | Pending, in-progress |
| `danger` | `red-500` | `#EF4444` | Errors, delete |
| `info` | `teal-500` | `#14B8A6` | Info badges |
| `surface` | `white` | `#FFFFFF` | Card backgrounds |
| `surface-alt` | `gray-50` | `#F9FAFB` | Page background |
| `border` | `gray-200` | `#E5E7EB` | Dividers, borders |
| `text-primary` | `gray-900` | `#111827` | Headings |
| `text-secondary` | `gray-600` | `#4B5563` | Body text |
| `text-muted` | `gray-400` | `#9CA3AF` | Placeholders |

### 1.2 Typography

- **Font Family**: Inter (sans-serif for English + Bengali numeral support)
- **Headings**: `font-semibold`
  - H1: `text-2xl` (32px)
  - H2: `text-xl` (24px)
  - H3: `text-lg` (18px)
  - H4: `text-base font-semibold` (16px)
- **Body**: `text-sm` (14px) — dense data tables
- **Small**: `text-xs` (12px) — metadata, timestamps
- **Monospace**: `font-mono` for shipment numbers, truck IDs

### 1.3 Shadows

| Level | Class | Usage |
|-------|-------|-------|
| Card | `shadow-sm` | Default cards |
| Elevated | `shadow-md` | Dropdowns, modals |
| High | `shadow-lg` | Sidebar, navbar |
| Toast | `shadow-xl` | Flash messages, notifications |

### 1.4 Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `sm` | `rounded` (4px) | Inputs, small buttons |
| `md` | `rounded-lg` (8px) | Cards, modals |
| `lg` | `rounded-xl` (12px) | Dashboard stats cards |
| `full` | `rounded-full` | Badges, avatars |

---

## 2. Layout & Navigation

### 2.1 Responsive Layout Structure

```
┌─────────────────────────────────────┐
│            TOP NAVBAR                │
├──────────┬──────────────────────────┤
│          │                          │
│          │                          │
│ SIDEBAR  │     MAIN CONTENT         │
│          │                          │
│ (256px)  │    (flex-1)              │
│          │                          │
├──────────┴──────────────────────────┤
│           FOOTER (minimal)           │
└─────────────────────────────────────┘
```

**Breakdown:**
- **Desktop (≥1024px)**: Sidebar visible, top navbar fixed
- **Tablet (768-1023px)**: Sidebar collapsed to icons, expands on hover
- **Mobile (<768px)**: Sidebar hidden, hamburger menu + bottom mobile nav

### 2.2 Sidebar (Desktop)

```
┌──────────────────┐
│  ┌──┐ Logo       │
│  │📦│ TSM System  │
│  └──┘ v1.0       │
├──────────────────┤
│ 🏠  Dashboard    │
│ 🚛  Trucks       │  ← active: bg-blue-50
│ 👨‍✈️  Drivers      │     text-blue-700
│ 📦  Products     │     border-l-4 border-blue-600
│ 📋  Shipments    │
│ 📍  Locations    │
│ 🗺️  Routes       │
├──────────────────┤
│ 📊  Reports      │
│ 🔔  Notifications│
├──────────────────┤
│ 📝  Audit Log    │  ← admin only
│ ⚙️  Settings     │  ← admin only
├──────────────────┤
│ Masum Didar      │
│ Super Admin      │
│ [Sign Out]       │
└──────────────────┘
```

### 2.3 Top Navbar

```
┌──────────────────────────────────────────────┐
│ 📦 TSM System    Dashboard    │ 🔔(3)  👤 ▾  │
└──────────────────────────────────────────────┘
```

- Left: Breadcrumbs (Home > Shipments > SH-20260702-0001)
- Right: Notification bell with unread count badge, user avatar dropdown

### 2.4 Mobile Bottom Navigation

```
┌────────────────────────────────────────┐
│  🏠  │  📋  │  🚛  │  🔔  │  👤       │
│ Home  │Shipmts│Trucks │Notif │ Profile  │
└────────────────────────────────────────┘
```

---

## 3. Component Library

### 3.1 Cards

```html
<!-- Stat Card -->
<div class="bg-white rounded-xl shadow-sm border border-gray-200 p-5
            hover:shadow-md transition-shadow duration-200">
  <div class="flex items-center justify-between">
    <div>
      <p class="text-sm text-gray-500 font-medium">Today's Export</p>
      <p class="text-3xl font-bold text-blue-600 mt-1">24</p>
    </div>
    <div class="w-12 h-12 bg-blue-50 rounded-full flex items-center justify-center text-xl">
      📤
    </div>
  </div>
  <div class="mt-3 text-xs text-green-600">↑ 12% from yesterday</div>
</div>
```

### 3.2 Tables

```html
<!-- Data Table -->
<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
  <div class="overflow-x-auto">
    <table class="min-w-full divide-y divide-gray-200">
      <thead>
        <tr class="bg-gray-50">
          <th class="px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider">#</th>
          ...
        </tr>
      </thead>
      <tbody class="divide-y divide-gray-100">
        <tr class="hover:bg-blue-50/50 transition-colors duration-150">
          ...
        </tr>
        <!-- Empty state -->
        <tr>
          <td colspan="7">
            <div class="text-center py-12">
              <div class="text-4xl mb-3">📋</div>
              <p class="text-gray-500 font-medium">No shipments yet</p>
              <p class="text-gray-400 text-sm mt-1">Create your first shipment to get started</p>
              <a href="#" class="mt-3 inline-block bg-blue-600 text-white px-4 py-2 rounded-lg text-sm">+ New Shipment</a>
            </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  <!-- Pagination -->
  <div class="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
    <p class="text-sm text-gray-500">Showing 1-10 of 45</p>
    <div class="flex gap-1">
      <button class="px-3 py-1 rounded border text-sm">←</button>
      <button class="px-3 py-1 rounded bg-blue-600 text-white text-sm">1</button>
      <button class="px-3 py-1 rounded border text-sm">2</button>
      <button class="px-3 py-1 rounded border text-sm">→</button>
    </div>
  </div>
</div>
```

### 3.3 Buttons

| Variant | Classes | Usage |
|---------|---------|-------|
| Primary | `bg-blue-600 text-white hover:bg-blue-700` | Main CTA |
| Secondary | `bg-white border border-gray-300 text-gray-700 hover:bg-gray-50` | Cancel, back |
| Danger | `bg-red-600 text-white hover:bg-red-700` | Delete |
| Ghost | `text-gray-600 hover:bg-gray-100` | Icon buttons |
| Link | `text-blue-600 hover:text-blue-800 underline` | Inline actions |

Sizes: `px-3 py-1.5 text-sm` (sm), `px-4 py-2 text-sm` (md), `px-6 py-3 text-base` (lg)

### 3.4 Form Inputs

```html
<div class="space-y-1">
  <label class="block text-sm font-medium text-gray-700">
    Shipment Type <span class="text-red-500">*</span>
  </label>
  <select class="block w-full rounded-lg border border-gray-300 px-3 py-2 text-sm
                 focus:ring-2 focus:ring-blue-500 focus:border-blue-500
                 transition-shadow duration-150
                 disabled:bg-gray-100 disabled:cursor-not-allowed">
    <option value="">Select Type</option>
    ...
  </select>
  <p class="text-xs text-red-500 hidden" data-error>This field is required</p>
</div>
```

### 3.5 Status Badges

```html
<!-- Status Badge variants -->
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium
             bg-yellow-100 text-yellow-800">Pending</span>
<span class="... bg-blue-100 text-blue-800">Loading</span>
<span class="... bg-indigo-100 text-indigo-800">Loaded</span>
<span class="... bg-purple-100 text-purple-800">On The Way</span>
<span class="... bg-teal-100 text-teal-800">Reached</span>
<span class="... bg-orange-100 text-orange-800">Unloading</span>
<span class="... bg-green-100 text-green-800">Completed</span>
```

### 3.6 Empty States

```
┌───────────────────────────────┐
│                               │
│           🚛                  │
│     No Trucks Found           │
│  Add your first truck to      │
│  start managing your fleet    │
│                               │
│  ┌───────────────────┐        │
│  │  + Add Truck      │        │
│  └───────────────────┘        │
│                               │
└───────────────────────────────┘
```

### 3.7 Loading States (Skeleton)

```html
<div class="animate-pulse space-y-3">
  <div class="h-4 bg-gray-200 rounded w-3/4"></div>
  <div class="h-4 bg-gray-200 rounded w-1/2"></div>
  <div class="h-10 bg-gray-200 rounded"></div>
</div>
```

### 3.8 Flash Messages (Toast)

- Fixed bottom-right on desktop, bottom-center on mobile
- Auto-dismiss after 4s (Stimulus controller already exists)
- Types: success (green), error (red), warning (yellow), info (blue)
- Slide-in animation from right

---

## 4. Page-by-Page UI Plan

### 4.1 🔐 Login Page

```
┌──────────────────────────────┐
│                              │
│        ┌────────────┐        │
│        │  📦 TSM    │        │
│        └────────────┘        │
│     Transport & Shipment     │
│     Management System        │
│                              │
│  ┌────────────────────────┐  │
│  │ Email                  │  │
│  ├────────────────────────┤  │
│  │ Password               │  │
│  ├────────────────────────┤  │
│  │  Remember me ☐        │  │
│  ├────────────────────────┤  │
│  │  [ Sign In ]          │  │
│  └────────────────────────┘  │
│                              │
│  © 2026 TSM System           │
└──────────────────────────────┘
```

- Centered card on gradient background
- Company logo at top
- Clean form with proper error states
- Responsive: full-width on mobile, card on desktop

### 4.2 📊 Dashboard

**Layout:**
```
┌──────────────────────────────────────┐
│ 📊 Dashboard               [Date]    │
├──────────────────────────────────────┤
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐│
│ │📤 24 │ │📥 18 │ │🚛 12 │ │✅ 8  ││
│ │Export│ │Import│ │Active│ │Cmpltd││
│ │↑ 12% │ │↓ 3%  │ │100%  │ │80%   ││
│ └──────┘ └──────┘ └──────┘ └──────┘│
├──────────────────────────────────────┤
│ ┌─────────────────┐ ┌──────────────┐│
│ │   Status Chart   │ │  Top Routes  ││
│ │   (bar chart)    │ │ 1. CGP→DHK   ││
│ │                  │ │ 2. DHK→BNP   ││
│ └─────────────────┘ └──────────────┘│
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │  Recent Shipments (table)        │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

- KPI cards with trend indicators (↑↓)
- Status distribution chart (pure CSS bars, no JS chart lib)
- Recent activity feed
- Quick action buttons

### 4.3 📋 Shipment List (Index)

```
┌──────────────────────────────────────┐
│ 📋 Shipments            [+ New]      │
├──────────────────────────────────────┤
│ [Search...] [Type▾] [Status▾] [Filter]│
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ #     │Type│ Route     │Status  │ │
│ ├──────┼────┼───────────┼───────┤ │
│ │SH-001│📤  │CGP → DHK  │✅ Cmplt│ │
│ │SH-002│📥  │DHK → CGP  │🔄 Load │ │
│ │SH-003│📤  │BNP → DHK  │⏳ Pndng│ │
│ └──────────────────────────────────┘ │
│ ← 1 2 3 ... 10 →                     │
└──────────────────────────────────────┘
```

- Search bar with debounced input (Stimulus)
- Multi-filter with clear button
- Sortable column headers
- Row actions: View, Edit, Delete (with confirmation modal)
- Responsive: table scrolls horizontally on mobile, card layout on very small screens

### 4.4 ✏️ Shipment Form (New/Edit)

- **Multi-step** or **single-page** with clear sections
- Section 1: Basic Info (type, date, locations)
- Section 2: Route & Truck assignment
- Section 3: Products (dynamic nested form with Stimulus)
- Section 4: Notes & additional info
- **Form validation**: inline error messages below fields
- **Auto-save**: draft saved locally (localStorage)

### 4.5 👁️ Shipment Detail

```
┌──────────────────────────────────────┐
│ SH-20260702-0001        [Edit] [←]   │
├──────────────────────────────────────┤
│ 📤 Export     🚛 D-1234     📅 02/07 │
├──────────────────────────────────────┤
│ Timeline                              │
│ ┌──┐                                  │
│ │✅│ Pending      02 Jul 09:00       │
│ ├──┤                                  │
│ │✅│ Loading      02 Jul 10:30       │
│ ├──┤                                  │
│ │⏳│ Loaded      (in progress)       │
│ ├──┤                                  │
│ │○ │ On The Way                       │
│ ├──┤                                  │
│ │○ │ Reached                          │
│ ├──┤                                  │
│ │○ │ Unloading                        │
│ ├──┤                                  │
│ │○ │ Completed                        │
│ └──┘                                  │
├──────────────────────────────────────┤
│ Products (table)                      │
│ Locations (source → destination)     │
│ Activity Log (all status changes)    │
└──────────────────────────────────────┘
```

- Sticky action bar (status update buttons)
- Vertical timeline with animation
- Card sections with collapsible content
- Status update buttons only show valid next transitions

### 4.6 🚛 Truck Detail

```
┌──────────────────────────────────────┐
│ 🚛 D-1234              [Edit] [←]    │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ Status: ✅ Available              │ │
│ │ Type: Company  │ Capacity: 15T   │ │
│ │ Location: Dhaka ICD              │ │
│ │ Driver: Abdul Karim  👤          │ │
│ └──────────────────────────────────┘ │
├──────────────────────────────────────┤
│ 📍 Current Location on Map (static)  │
├──────────────────────────────────────┤
│ 📋 Current Shipment (if assigned)    │
├──────────────────────────────────────┤
│ 👨‍✈️ Driver Assignment History         │
└──────────────────────────────────────┘
```

### 4.7 👨‍✈️ Driver Detail

```
┌──────────────────────────────────────┐
│ 👨‍✈️ Abdul Karim          [Edit] [←]  │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ Status: 🚗 Driving               │ │
│ │ Phone: 01812-345678              │ │
│ │ License: LIC-12345678            │ │
│ │ Truck: D-1234 (since 02 Jul)     │ │
│ └──────────────────────────────────┘ │
├──────────────────────────────────────┤
│ ⏱️ Assignment Timeline                │
│ ┌──────────────────────────────────┐ │
│ │ ✅ Assigned → D-1234 02 Jul 09:00│ │
│ │ 🔄 Released ← D-5678 01 Jul 18:00│ │
│ │ ✅ Assigned → D-5678 01 Jul 08:00│ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### 4.8 📊 Reports

```
┌──────────────────────────────────────┐
│ 📊 Reports                           │
├──────────────────────────────────────┤
│ [Daily] [Weekly] [Monthly] [Custom]  │
├──────────────────────────────────────┤
│ ┌──────────────────────────────────┐ │
│ │ Date: [2026-07-02]               │ │
│ │                                  │ │
│ │ ┌──────┐ ┌──────┐ ┌──────┐     │ │
│ │ │Export│ │Import│ │Total │     │ │
│ │ │  24  │ │  18  │ │  42  │     │ │
│ │ └──────┘ └──────┘ └──────┘     │ │
│ │                                  │ │
│ │ Route-wise breakdown (table)    │ │
│ │ Truck-wise breakdown (table)    │ │
│ │                                  │ │
│ │ [📥 Download CSV]               │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
```

### 4.9 🔔 Notifications

- List view with unread indicator (blue dot)
- Click to mark as read
- "Mark All Read" button
- Infinite scroll or pagination
- Notification types with icons

### 4.10 ⚙️ Settings

```
┌──────────────────────────────────────┐
│ ⚙️ Settings                          │
├──────────────────────────────────────┤
│ ┌──────┬───────────────────────────┐ │
│ │General│ Company Name: [TSM Ltd]  │ │
│ │Notifs │ Address: [....]          │ │
│ │Reports│ Phone: [....]            │ │
│ │       │ Currency: [BDT ▾]        │ │
│ │       │                           │ │
│ │       │ [Save Changes]            │ │
│ └──────┴───────────────────────────┘ │
└──────────────────────────────────────┘
```

- Tab-based navigation for setting groups
- Inline edit with auto-save
- Grouped by category

---

## 5. Interactive Features (Stimulus + Turbo)

### 5.1 Stimulus Controllers to Build

| Controller | Purpose | Priority |
|------------|---------|----------|
| `search_controller` | Debounced search input with loading state | P1 |
| `filter_controller` | Multi-filter with clear, URL params sync | P1 |
| `modal_controller` | Reusable confirm/delete modal | P1 |
| `dropdown_controller` | User menu, action dropdowns | P1 |
| `tooltip_controller` | Hover tooltips on icons | P2 |
| `tabs_controller` | Tab navigation (settings, detail pages) | P1 |
| `autocomplete_controller` | Location/truck search with suggestions | P2 |
| `sortable_table_controller` | Click-to-sort column headers | P2 |
| `chart_controller` | Inline CSS bar/donut charts | P2 |
| `toast_controller` | Stackable toast notifications | P1 |
| `confirm_controller` | Turbo confirm dialogs with custom styling | P1 |
| `infinite_scroll_controller` | Pageless scrolling for logs | P2 |

### 5.2 Turbo Stream Channels

| Channel | Trigger | Target |
|---------|---------|--------|
| `notification_count` | New notification created | Navbar badge |
| `shipment_status` | Status updated | Timeline + badge |
| `truck_status` | Truck assigned/released | Truck card |
| `driver_status` | Driver assigned/released | Driver card |

### 5.3 Animations & Transitions

- Page transitions: fade-in via Turbo Drive (`<meta name="turbo-visit-control" content="reload">` or custom CSS)
- Sidebar: smooth slide on mobile
- Timeline: staggered reveal
- Status badges: pulse animation when recently updated
- Table rows: highlight on change (yellow fade)
- Flash messages: slide-in right, fade-out

---

## 6. Bengali Language Support

### 6.1 Strategy

- Use **I18n** for all UI text (Rails built-in)
- Default locale: `en`, fallback: `bn`
- Locale toggle in navbar
- Date/time formatting with Bengali numerals

### 6.2 Bengali Labels for Key Pages

| English | বাংলা |
|---------|-------|
| Dashboard | ড্যাশবোর্ড |
| Shipments | চালান |
| Trucks | ট্রাক |
| Drivers | চালক |
| Products | পণ্য |
| Locations | অবস্থান |
| Routes | রুট |
| Reports | রিপোর্ট |
| Notifications | বিজ্ঞপ্তি |
| Settings | সেটিংস |
| Source | উৎস |
| Destination | গন্তব্য |
| Status | অবস্থা |
| Pending | অপেক্ষমাণ |
| Loading | লোডিং |
| Loaded | লোডকৃত |
| On The Way | পথে |
| Reached | পৌঁছেছে |
| Unloading | আনলোডিং |
| Completed | সম্পন্ন |
| Create New | নতুন তৈরি |
| Edit | সম্পাদনা |
| Delete | মুছুন |
| Search | অনুসন্ধান |
| Filter | ফিল্টার |
| Today | আজ |
| This Week | এই সপ্তাহ |
| This Month | এই মাস |

### 6.3 Bengali Calendar Support

- Date picker with Bengali month names
- `bn` locale in `config/application.rb`
- Helper method `l_bn(object.date)` for Bengali date display

---

## 7. Responsive Breakpoints

| Breakpoint | Width | Layout |
|------------|-------|--------|
| `sm` | ≥640px | Single column, horizontal form labels |
| `md` | ≥768px | Two column grid, sidebar icons |
| `lg` | ≥1024px | Full sidebar, three+ column grids |
| `xl` | ≥1280px | Max-width container (1280px) |

### 7.1 Responsive Patterns

| Component | Mobile (<768px) | Tablet (768-1023px) | Desktop (≥1024px) |
|-----------|-----------------|---------------------|-------------------|
| Sidebar | Hidden (hamburger) | Collapsed icons | Full (256px) |
| Tables | Card list | Scrollable table | Full table |
| Filters | Vertical stack | Inline wrap | Single row |
| Forms | Single column | 2 columns | 2-3 columns |
| Dashboard | 2×2 grid | 4 column | 4 column |
| Modals | Full screen | Centered | Centered |

### 7.2 Mobile Navigation

```
Bottom Nav (iPhone-style):
┌────────────────────────────────────┐
│  🏠    📋    🚛    🔔    👤       │
│ Home  Ship   Truck  Notif  Profile │
└────────────────────────────────────┘
```

- Fixed bottom bar, 50px height
- Active tab highlighted
- Replace sidebar entirely on mobile

---

## 8. Accessibility

### 8.1 Standards

- All interactive elements focusable and keyboard-navigable
- ARIA labels on icon-only buttons
- Color contrast ratios ≥ 4.5:1
- Form inputs linked to labels
- Error messages announced by screen readers

### 8.2 Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+K` | Global search |
| `Ctrl+N` | New record (context-aware) |
| `Escape` | Close modal/dropdown |
| `?` | Show keyboard shortcuts |

### 8.3 Focus Management

- Focus ring: `focus:ring-2 focus:ring-blue-500 focus:outline-none`
- Modal: trap focus inside
- Turbo: restore scroll position on back navigation

---

## 9. Implementation Order

| Phase | Tasks | Est. Time |
|-------|-------|-----------|
| **Phase 1: Foundation** | Design system (colors, typography), Layout (sidebar, navbar, mobile nav), Component base classes | 2 days |
| **Phase 2: Core Pages** | Login page, Dashboard, Shipment List + Detail, Truck List + Detail, Driver List + Detail | 3 days |
| **Phase 3: Forms & Interactions** | Shipment form (with dynamic products), All CRUD forms, Stimulus controllers (search, filter, modal, dropdown), Form validation styling | 3 days |
| **Phase 4: Advanced UI** | Reports page, Settings page, Notification list, Audit log, Bengali locale + I18n | 2 days |
| **Phase 5: Polish** | Empty states, Loading skeletons, Animations, Responsive testing, Accessibility audit | 2 days |

**Total estimated: 12 days**

---

## Appendix: Tech Stack

| Tool | Purpose |
|------|---------|
| Tailwind CSS v3 | Utility CSS framework |
| Tailwind Config | Custom theme (colors, spacing) |
| Stimulus JS | Interactive behavior |
| Turbo Drive + Frames | Page navigation, partial updates |
| I18n (Rails) | Bengali language support |
| ViewComponent (optional) | Reusable UI component classes |

---

*Document version: 1.0 — Last updated: July 2026*
