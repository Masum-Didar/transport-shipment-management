module ApplicationHelper
  def locale_label
    I18n.locale == :en ? "English" : "বাংলা"
  end

  def t_model(model_key, count = 1)
    I18n.t("models.#{model_key}", count: count)
  end

  def nav_link(label, path, icon_name = nil)
    active = current_page?(path)
    icon_html = icon_name ? send("#{icon_name}_icon") : ""
    link_to path, data: { label: label }, class: "w-full flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-all duration-150 #{active ? 'bg-blue-600 text-white shadow-sm' : 'text-slate-300 hover:bg-slate-700 hover:text-white'}" do
      safe_join([icon_html, tag.span(label, class: "sidebar-label")])
    end
  end

  def sidebar_section(title = nil, &block)
    content = capture(&block)
    html = "<div class='pt-3 pb-1 px-1'><div class='h-px bg-slate-700'></div>"
    if title
      html += "<p class='text-xs text-slate-500 font-medium px-2 pt-2 pb-1 uppercase tracking-wider'>#{title}</p>"
    end
    html += "</div>#{content}"
    raw(html)
  end

  def status_badge(status)
    colors = {
      "pending"     => ["bg-yellow-100", "text-yellow-800", "bg-yellow-400"],
      "loading"     => ["bg-blue-100",   "text-blue-800",   "bg-blue-400"],
      "loaded"      => ["bg-indigo-100", "text-indigo-800", "bg-indigo-400"],
      "on_the_way"  => ["bg-purple-100", "text-purple-800", "bg-purple-400"],
      "reached"     => ["bg-teal-100",   "text-teal-800",   "bg-teal-400"],
      "unloading"   => ["bg-orange-100", "text-orange-800", "bg-orange-400"],
      "completed"   => ["bg-green-100",  "text-green-800",  "bg-green-400"],
      "available"   => ["bg-green-100",  "text-green-800",  "bg-green-400"],
      "assigned"    => ["bg-blue-100",   "text-blue-800",   "bg-blue-400"],
      "on_route"    => ["bg-purple-100", "text-purple-800", "bg-purple-400"],
      "maintenance" => ["bg-red-100",    "text-red-800",    "bg-red-400"],
      "inactive"    => ["bg-gray-100",   "text-gray-800",   "bg-gray-400"],
      "active"      => ["bg-green-100",  "text-green-800",  "bg-green-400"],
      "driving"     => ["bg-blue-100",   "text-blue-800",   "bg-blue-400"],
      "leave"       => ["bg-yellow-100", "text-yellow-800", "bg-yellow-400"],
      "off_duty"    => ["bg-gray-100",   "text-gray-600",   "bg-gray-400"],
      "import"      => ["bg-purple-100", "text-purple-800", "bg-purple-400"],
      "export"      => ["bg-indigo-100", "text-indigo-800", "bg-indigo-400"]
    }
    bg, text, dot = colors[status] || ["bg-gray-100", "text-gray-800", "bg-gray-400"]
    content_tag :span, class: "inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium #{bg} #{text}" do
      safe_join([
        content_tag(:span, "", class: "w-1.5 h-1.5 rounded-full #{dot}"),
        status.titleize
      ])
    end
  end

  # ─── SVG Icons (Lucide-compatible style) ────────────────────────────────

  def dashboard_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>')
  end

  def clipboard_list_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="8" height="4" x="8" y="2" rx="1" ry="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg>')
  end

  def truck_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>')
  end

  def users_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>')
  end

  def package_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z"/><path d="M12 22V12"/><path d="m3.3 7 7.703 4.734a2 2 0 0 0 1.994 0L20.7 7"/><path d="m7.5 4.27 9 5.15"/></svg>')
  end

  def map_pin_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>')
  end

  def map_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.106 5.553a2 2 0 0 0-1.138-1.038L3.5 1.5 1.5 3.5l3.015 9.468a2 2 0 0 0 1.038 1.138l7.514 3.241a2 2 0 0 0 2.586-2.586Z"/><path d="M7.5 7.5 3 12l1.5 1.5"/><path d="m12 3 1.5 1.5L12 9.5"/><path d="M20.5 14.5a2.5 2.5 0 0 0-3 4 2.5 2.5 0 0 0 3-4Z"/><path d="M14.5 20.5 21 14l1.5 1.5-4.5 6Z"/></svg>')
  end

  def bar_chart_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" x2="12" y1="20" y2="10"/><line x1="18" x2="18" y1="20" y2="4"/><line x1="6" x2="6" y1="20" y2="16"/></svg>')
  end

  def bell_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M6 8a6 6 0 0 1 12 0c0 7 4 11 4 11H2s4-4 4-11"/><path d="M9.5 17c0 .587.265 1.148.732 1.563.468.414 1.103.647 1.768.647.665 0 1.3-.233 1.768-.647.467-.415.732-.976.732-1.563"/></svg>')
  end

  def file_text_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg>')
  end

  def settings_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/></svg>')
  end

  def log_out_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/></svg>')
  end

  def menu_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg>')
  end

  def x_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6 6 18"/><path d="m6 6 12 12"/></svg>')
  end

  def chevron_right_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m9 18 6-6-6-6"/></svg>')
  end

  def chevron_down_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 9 6 6 6-6"/></svg>')
  end

  def globe_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/><path d="M2 12h20"/></svg>')
  end

  def search_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>')
  end

  def user_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>')
  end

  def eye_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>')
  end

  def edit_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 3a2.85 2.83 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5Z"/><path d="m15 5 4 4"/></svg>')
  end

  def trash_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/></svg>')
  end

  def plus_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14"/><path d="M12 5v14"/></svg>')
  end

  def filter_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>')
  end

  def download_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>')
  end

  def check_circle_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>')
  end

  def home_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>')
  end

  def arrow_up_right_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 7h10v10"/><path d="M7 17 17 7"/></svg>')
  end

  def arrow_down_right_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M7 7h10v10"/><path d="M17 7 7 17"/></svg>')
  end

  def check_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>')
  end

  def clock_icon
    raw('<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>')
  end

  def nav_items_for_mobile
    items = [
      { path: root_path,         icon: :dashboard_icon,  label: "Dashboard" },
      { path: shipments_path,    icon: :clipboard_list_icon, label: "Shipments" },
      { path: trucks_path,       icon: :truck_icon,      label: "Trucks" },
      { path: drivers_path,      icon: :users_icon,      label: "Drivers" },
      { path: products_path,     icon: :package_icon,    label: "Products" },
      { path: locations_path,    icon: :map_pin_icon,    label: "Locations" },
      { path: routes_path,       icon: :map_icon,        label: "Routes" },
      { path: reports_daily_path, icon: :bar_chart_icon, label: "Reports" },
      { path: notifications_path, icon: :bell_icon,      label: "Notifications" },
    ]
    items << { path: audit_logs_path, icon: :file_text_icon, label: "Audit Log" } if current_user&.admin?
    items << { path: settings_path, icon: :settings_icon, label: "Settings" } if current_user&.admin?
    items
  end

  def bottom_nav_items
    [
      { path: root_path,          icon: :home_icon,      label: "Home" },
      { path: shipments_path,     icon: :clipboard_list_icon, label: "Shipments" },
      { path: trucks_path,        icon: :truck_icon,     label: "Trucks" },
      { path: notifications_path, icon: :bell_icon,      label: "Notif", badge: true },
      { path: settings_path,      icon: :user_icon,      label: "Profile" },
    ]
  end
end
