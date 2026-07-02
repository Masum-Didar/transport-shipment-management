# UI Design Migration Plan: ui-design → tsm-system

## 1. Design System Analysis Summary

The ui-design project uses a polished design system built on **Tailwind CSS v4** with these key characteristics:

| Element | Design Reference | Current Rails State |
|---------|-----------------|---------------------|
| **Page BG** | `bg-gray-50` | Same ✅ |
| **Card BG** | White, `rounded-xl border border-gray-200 shadow-sm` | `rounded-lg shadow` (no border, different radius) |
| **Sidebar BG** | `bg-slate-800` | `bg-gray-900` |
| **Sidebar active** | `bg-blue-600 text-white shadow-sm` | `bg-gray-700 text-white` |
| **Sidebar inactive** | `text-slate-300 hover:bg-slate-700 hover:text-white` | `text-gray-300 hover:bg-gray-800 hover:text-white` |
| **Sidebar width** | `w-64` | Same ✅ |
| **Sidebar layout** | `fixed inset-y-0 left-0 z-30` | `fixed left-0 top-0 h-full z-40` |
| **Navbar** | `fixed top-0 right-0 left-0 lg:left-64 z-20 h-14`, white bg, border-b | Static, no fixed position, `.ml-64` handled by flex |
| **Navbar content** | Breadcrumbs + Locale toggle + Bell + User dropdown | Title + Bell |
| **Primary button** | `bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium hover:bg-blue-700 transition-colors` | `bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700` (no transition) |
| **Secondary button** | `bg-white border border-gray-300 text-gray-700 hover:bg-gray-50` | `bg-gray-100 text-gray-700 hover:bg-gray-200` |
| **Buttons sizing** | 3 sizes: sm/md/lg with specific px/py | Inconsistent |
| **Form inputs** | `rounded-lg border border-gray-300 px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 focus:border-blue-500 outline-none transition` | `rounded border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500` |
| **Status badges** | `inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium` with colored dot | `inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium` (no dot) |
| **Stat cards** | `rounded-xl shadow-sm border border-gray-200 p-5 hover:shadow-md transition-shadow`, icon in colored bg circle | `rounded-lg shadow p-5 border-l-4 border-{color}` |
| **Tables** | `min-w-full`, thead: `bg-gray-50 border-b border-gray-200 th: px-4 py-3 text-left text-xs font-semibold text-gray-500 uppercase tracking-wider`, tbody: `divide-y divide-gray-100 tr.hover:bg-blue-50/40 transition-colors` | Similar but with `divide-gray-200`, no tracking-wider/hover transition |
| **Font** | Inter + JetBrains Mono + Hind Siliguri (Google Fonts) | System fonts only |
| **Typography** | H1: `text-xl font-semibold text-gray-900`, H2: `text-sm font-semibold text-gray-900` (section headings) | `text-xl font-semibold text-gray-800` |
| **Page content area** | `lg:ml-64 pt-14 pb-20 lg:pb-6 p-4 lg:p-6` | `ml-64`, no pt/pb, `p-6` |
| **Mobile layout** | Hidden sidebar + overlay + bottom navigation bar | No mobile nav |
| **Empty states** | `py-14` centered with emoji + message + subtitle + CTA | Simple `py-8` text |
| **Pagination** | Styled with border buttons, active page in blue | Uses Pagy (Bootstrap extras) |
| **Icons** | Lucide React icons | Emoji (😃) |
| **Locale** | Built-in EN/BN translations | Not implemented |
| **Responsive** | `lg:` breakpoint for sidebar, `sm:` for grids | Default Tailwind |

---

## 2. Key Design Token Differences

### Colors
- **Sidebar**: Change `bg-gray-900` → `bg-slate-800` (`#1E293B`)
- **Cards**: Add `border border-gray-200` + change `rounded-lg` → `rounded-xl` + `shadow-sm`
- **Empty states**: Match `text-gray-500 font-medium` heading + `text-gray-400 text-sm mt-1` subtext
- **Status badge colors**: Slight differences — e.g., "On The Way" in design uses `bg-purple-100 text-purple-800` vs current `bg-orange-100 text-orange-800`. Design adds green dot indicator.

### Typography
- Add **Inter** (primary), **JetBrains Mono** (monospace IDs), **Hind Siliguri** (Bengali) fonts
- Change H1 from `text-gray-800` to `text-gray-900`, section headings from `font-semibold text-gray-700` to `text-sm font-semibold text-gray-900`
- Add `font-mono` class to shipment numbers, truck IDs, driver phone/license

### Layout
- Fix navbar to top (change from static to fixed)
- Add proper responsive padding: `lg:ml-64 pt-14 pb-20 lg:pb-6`
- Add padding: `p-4 lg:p-6` inside main
- Add mobile sidebar overlay (absolute positioned, backdrop)
- Add mobile bottom navigation bar (`h-16`, fixed bottom, 5 tabs)
- Add breadcrumbs to navbar

---

## 3. Detailed Implementation Plan

### Phase 1: Foundation — Design System + Layout
*Estimated: 2 days*

**Goal**: Establish design tokens, fonts, global styles, and the core layout (sidebar, navbar, mobile nav, flash messages).

#### Files to Create:
| File | Purpose |
|------|---------|
| `app/assets/tailwind/application.css` | **Modify**: Add `@theme inline` block with design tokens, Google Fonts imports via `@import`, base layer styles |
| `app/assets/stylesheets/application.css` | **Modify**: Update manifest to include new CSS |
| `app/views/shared/_sidebar.html.erb` | **Rewrite**: Full redesign matching React `Sidebar` component — slate-800 BG, blue-600 active, logo with icon box, 3 nav groups, user profile with avatar |
| `app/views/shared/_navbar.html.erb` | **Rewrite**: Full redesign matching React `Navbar` — fixed top, breadcrumbs, locale toggle, notification bell with badge, user avatar dropdown |
| `app/views/shared/_mobile_sidebar.html.erb` | **Create**: Mobile overlay sidebar (hidden on lg+, toggled via stimulus) |
| `app/views/shared/_bottom_nav.html.erb` | **Create**: iOS-style bottom navigation bar (hidden on lg+, fixed bottom) |
| `app/views/shared/_flash.html.erb` | **Rewrite**: Toast-style flash messages with slide-in animation, positioned bottom-right |
| `app/views/layouts/application.html.erb` | **Modify**: Fix navbar, add responsive padding, mobile nav, mobile sidebar reference, body class `bg-gray-50 font-sans` |
| `app/helpers/application_helper.rb` | **Rewrite** `nav_link`: Add icon support with Lucide-compatible SVG icons, match new design active/inactive styles |
| `app/javascript/controllers/sidebar_controller.js` | **Create**: Toggle mobile sidebar open/close |
| `app/javascript/controllers/dropdown_controller.js` | **Create**: User menu dropdown in navbar, action dropdowns in tables |
| `Gemfile` | Add `view_component` gem |

#### Files to Modify:
- `app/views/layouts/application.html.erb` — new layout structure
- `app/helpers/application_helper.rb` — new `nav_link`, `status_badge` with dot indicator
- `app/assets/tailwind/application.css` — design tokens, fonts, base styles

**Visual changes**: Sidebar becomes slate-800 with blue-600 active items, logo with icon box "📦", 3 nav groups. Navbar becomes fixed with breadcrumbs + locale toggle + bell + user dropdown. Mobile gets overlay sidebar + bottom nav.

---

### Phase 2: Core Pages — Dashboard, Shipments, Trucks, Drivers
*Estimated: 3 days*

**Goal**: Redesign all list and detail pages with new card/table/button/status badge styling.

#### 2A: Components & Helpers

| File | Purpose |
|------|---------|
| `app/components/stat_card_component.rb` + `.html.erb` | Reusable stat card with icon, value, trend, color-coded icon background |
| `app/components/status_badge_component.rb` + `.html.erb` | Status badge with dot indicator |
| `app/components/empty_state_component.rb` + `.html.erb` | Empty state with emoji, title, description, optional CTA |
| `app/helpers/application_helper.rb` | **Modify**: Update `status_badge` to include dot `<span>`, update color mappings to match design spec exactly |
| `app/helpers/application_helper.rb` | **Modify**: Add `format_shipment_id`, `format_truck_id`, `format_driver_id` helpers with `font-mono` |
| `app/helpers/application_helper.rb` | **Add**: `pagy_nav` wrapper to style pagination per design |

#### 2B: Dashboard Page

| File | Purpose |
|------|---------|
| `app/views/dashboard/index.html.erb` | **Rewrite**: Stat cards in 4-column grid, weekly bar chart (CSS-only or simple chart), top routes list with progress bars, status breakdown list, recent shipments in styled table |
| `app/controllers/dashboard_controller.rb` | **Modify**: Add more stats — today_export, today_import, active_trucks, drivers_on_duty, status_counts for pie/bar |

#### 2C: Shipments

| File | Purpose |
|------|---------|
| `app/views/shipments/index.html.erb` | **Rewrite**: New filter bar with search icon inside input + selects in `rounded-xl border shadow-sm` filter panel, table with new styling (gray-50 thead, tracking-wider, hover:bg-blue-50/40), pagination bar, empty state component |
| `app/views/shipments/show.html.erb` | **Rewrite**: Back button → info cards row (type/truck/driver in icon cards) → 2-column layout with timeline + route details + products table + activity log |
| `app/views/shipments/_form.html.erb` | **Modify**: Update input/select styling to new design, update button styling, update card containers |

#### 2D: Trucks

| File | Purpose |
|------|---------|
| `app/views/trucks/index.html.erb` | **Rewrite**: Search bar → 3 stat pills (available/on trip/maintenance) → card grid (`grid-cols-1 sm:grid-cols-2 lg:grid-cols-3`) with truck icon, number, type, capacity, status badge, location, driver, shipment |
| `app/views/trucks/show.html.erb` | **Rewrite**: Back button → 3-column layout with truck info card (centered icon + details) → current shipment card → driver assignment history |
| `app/views/trucks/_form.html.erb` | **Modify**: Update styling |

#### 2E: Drivers

| File | Purpose |
|------|---------|
| `app/views/drivers/index.html.erb` | **Rewrite**: Search bar → table with avatar initials, name, phone, license, status badge, current truck, actions |
| `app/views/drivers/show.html.erb` | **Rewrite**: Back button → 3-column layout with profile card (large avatar, status badge, details) → assignment timeline |
| `app/views/drivers/_form.html.erb` | **Modify**: Update styling |

---

### Phase 3: Forms & Interactions — All CRUD + Stimulus Controllers
*Estimated: 3 days*

**Goal**: Standardize all form styling, add interactive behaviors (search, filter, modals, toasts).

#### Files to Create:
| File | Purpose |
|------|---------|
| `app/components/form_field_component.rb` + template | Reusable form field with label + input + error message |
| `app/components/modal_component.rb` + template | Reusable confirm/action modal |
| `app/components/button_component.rb` + template | Button with variants (primary/secondary/danger/ghost) and sizes (sm/md/lg) |
| `app/javascript/controllers/search_controller.js` | Debounced search input |
| `app/javascript/controllers/filter_controller.js` | Multi-filter with clear button |
| `app/javascript/controllers/modal_controller.js` | Custom confirm dialogs |
| `app/javascript/controllers/tabs_controller.js` | Tab navigation for settings |
| `app/javascript/controllers/toast_controller.js` | Toast notification stacking |

#### Files to Modify (all form partials):
- `app/views/products/_form.html.erb`
- `app/views/product_categories/_form.html.erb`
- `app/views/locations/_form.html.erb`
- `app/views/routes/_form.html.erb`
- `app/views/driver_assignments/index.html.erb`
- `app/views/audit_logs/index.html.erb`

---

### Phase 4: Advanced Pages — Reports, Settings, Notifications
*Estimated: 2 days*

**Goal**: Redesign remaining pages with new component system.

| File | Purpose |
|------|---------|
| `app/views/reports/daily.html.erb` | **Rewrite**: Period toggle (Daily/Weekly/Monthly/Custom), date picker, 3 summary stat cards, route breakdown table with progress bars |
| `app/views/reports/weekly.html.erb` | Same treatment |
| `app/views/reports/monthly.html.erb` | Same treatment |
| `app/views/notifications/index.html.erb` | **Rewrite**: Mark all read button, notification items with icon, text, time, unread dot indicator |
| `app/views/settings/index.html.erb` | **Rewrite**: Tab-based navigation (General/Notifications/Reports/Security), form fields per tab |
| `app/views/shared/_form_errors.html.erb` | **Modify**: Update styling |

---

### Phase 5: Polish — Empty States, Animations, Responsive, Bengali
*Estimated: 2 days*

**Goal**: Final polish, responsive testing, i18n, animations.

| File | Purpose |
|------|---------|
| `app/views/shared/_empty_state.html.erb` | Create reusable empty state partial |
| `config/locales/en.yml` | Add all English UI strings |
| `config/locales/bn.yml` | **Create**: Full Bengali locale with all UI translations |
| `app/helpers/application_helper.rb` | Add `l_bn` helper for Bengali date display |
| `app/javascript/controllers/animation_controller.js` | Timeline staggered reveal, fade-in page transitions |
| `app/assets/tailwind/application.css` | Add `tw-animate-css` utilities, custom animations |

---

## 4. Technology Mapping (React → Rails)

| React Feature | Rails Equivalent |
|---------------|-----------------|
| `useState` for page routing | Rails routing (Turbo Drive navigation) |
| `StatusBadge` component | `application_helper#status_badge` with dot HTML |
| `StatCard` component | `ViewComponent::StatCardComponent` |
| `Sidebar` component | `_sidebar.html.erb` partial |
| `Navbar` component | `_navbar.html.erb` partial |
| `MobileSidebar` | `_mobile_sidebar.html.erb` partial |
| `MobileBottomNav` | `_bottom_nav.html.erb` partial |
| `ShipmentsList` | `shipments/index.html.erb` |
| `ShipmentDetail` | `shipments/show.html.erb` |
| `TrucksList` | `trucks/index.html.erb` |
| `TruckDetail` | `trucks/show.html.erb` |
| `DriversList` | `drivers/index.html.erb` |
| `DriverDetail` | `drivers/show.html.erb` |
| `Reports` | `reports/daily.html.erb` etc. |
| `NotificationsPage` | `notifications/index.html.erb` |
| `SettingsPage` | `settings/index.html.erb` |
| `LoginPage` | Devise views |
| `tr(key, locale)` | Rails I18n (`t(key)`) |
| `Locale` state | Rails `I18n.locale` |
| `useState` for search/filter | Ransack + Stimulus controllers |
| `useState` for pagination | Pagy gem |
| Lucide icons | Inline SVGs or emoji (match design) |
| Recharts | CSS-only bars or Chartkick |
| shadcn/ui components | Custom ViewComponents |
| Tailwind CSS v4 theme | `@theme inline` in CSS |

---

## 5. Recommended Rails Folder Structure

```
app/
  assets/
    tailwind/
      application.css          # @import "tailwindcss" + @theme inline + @layer base
  components/                  # NEW - ViewComponents
    button_component.rb
    button_component.html.erb
    stat_card_component.rb
    stat_card_component.html.erb
    status_badge_component.rb
    status_badge_component.html.erb
    empty_state_component.rb
    empty_state_component.html.erb
    form_field_component.rb
    form_field_component.html.erb
    modal_component.rb
    modal_component.html.erb
  views/
    shared/
      _sidebar.html.erb        # REWRITTEN
      _navbar.html.erb         # REWRITTEN
      _mobile_sidebar.html.erb # NEW
      _bottom_nav.html.erb     # NEW
      _flash.html.erb          # REWRITTEN
      _empty_state.html.erb    # NEW
      _form_errors.html.erb    # MODIFIED
  javascript/
    controllers/
      sidebar_controller.js    # NEW
      dropdown_controller.js   # NEW
      search_controller.js     # NEW
      filter_controller.js     # NEW
      modal_controller.js      # NEW
      tabs_controller.js       # NEW
      toast_controller.js      # NEW
  helpers/
    application_helper.rb      # MODIFIED - status_badge with dot, nav_link with SVG
```

---

## 6. Key Visual Changes Per View

### Dashboard (before → after)
- **Before**: 7 stat cards with `border-l-4` colored borders + completion bar + table
- **After**: 4 KPI cards with `rounded-xl shadow-sm border` + icon in colored circle + trend arrows + bar chart + top routes + status breakdown + 2-column layout

### Shipments List (before → after)
- **Before**: Inline filter form + table with `bg-gray-50` hover + action emojis
- **After**: Styled filter panel with search icon + selects + 2-column table with `tracking-wider` headers + eye/edit/trash buttons + styled pagination

### Truck List (before → after)
- **Before**: Table with rows
- **After**: 3 stat pills (Available/On Trip/Maintenance) + card grid with truck icon, number, type, capacity, status, location, driver

### Settings (before → after)
- **Before**: Grouped cards with inline edit forms
- **After**: Tab navigation (General/Notifications/Reports/Security) with proper form sections

### Many Detail Pages (before → after)
- **Before**: Two-column layout with simple cards
- **After**: Back button + info summary cards row + 3-column layout with richer sections

---

## 7. Recommended Migration Order

1. **Phase 1** → Layout foundation (must be done first, everything depends on it)
2. **Phase 2A** → Shared components + helpers
3. **Phase 2B** → Dashboard (highest visibility page)
4. **Phase 2C–2E** → Shipments → Trucks → Drivers (core domain pages)
5. **Phase 3** → Forms + CRUD + Stimulus controllers (interaction layer)
6. **Phase 4** → Reports + Settings + Notifications
7. **Phase 5** → Polish + Bengali + animations

---

## 8. Total Estimated Effort

| Phase | Days | Files Created | Files Modified |
|-------|------|--------------|----------------|
| Phase 1: Foundation + Layout | 2 | 6 | 4 |
| Phase 2: Core Pages | 3 | 5 | 15 |
| Phase 3: Forms + Interactions | 3 | 10 | 10 |
| Phase 4: Advanced Pages | 2 | 0 | 7 |
| Phase 5: Polish | 2 | 2 | 5 |
| **Total** | **12** | **23** | **41** |
