module ApplicationHelper
  def nav_link(label, path, icon = nil)
    active = current_page?(path)
    icon_html = icon ? "#{icon} " : ""
    link_to path, class: "flex items-center px-3 py-2 rounded-lg text-sm #{active ? 'bg-gray-700 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white'}" do
      safe_join([raw(icon_html), label])
    end
  end

  def status_badge(status)
    colors = {
      "pending"    => "bg-yellow-100 text-yellow-800",
      "loading"    => "bg-blue-100 text-blue-800",
      "loaded"     => "bg-indigo-100 text-indigo-800",
      "on_the_way" => "bg-orange-100 text-orange-800",
      "reached"    => "bg-teal-100 text-teal-800",
      "unloading"  => "bg-purple-100 text-purple-800",
      "completed"  => "bg-green-100 text-green-800",
      "available"  => "bg-green-100 text-green-800",
      "assigned"   => "bg-blue-100 text-blue-800",
      "on_route"   => "bg-orange-100 text-orange-800",
      "maintenance"=> "bg-red-100 text-red-800",
      "inactive"   => "bg-gray-100 text-gray-800",
      "active"     => "bg-green-100 text-green-800",
      "driving"    => "bg-blue-100 text-blue-800",
      "leave"      => "bg-yellow-100 text-yellow-800",
      "import"     => "bg-purple-100 text-purple-800",
      "export"     => "bg-indigo-100 text-indigo-800"
    }
    color = colors[status] || "bg-gray-100 text-gray-800"
    content_tag :span, status.titleize, class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium #{color}"
  end
end
