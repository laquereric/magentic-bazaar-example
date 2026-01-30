module ApplicationHelper
  def nav_link(text, path, icon: nil)
    active = current_page?(path)
    css = active ? "bg-indigo-700 text-white" : "text-indigo-100 hover:bg-indigo-600 hover:text-white"

    link_to path, class: "group flex items-center gap-x-3 rounded-md p-2 text-sm font-semibold #{css}" do
      concat(content_tag(:span, icon, class: "text-lg")) if icon
      concat(text)
    end
  end

  def status_badge(status)
    colors = {
      "pending"   => "bg-yellow-100 text-yellow-800",
      "running"   => "bg-blue-100 text-blue-800",
      "completed" => "bg-green-100 text-green-800",
      "failed"    => "bg-red-100 text-red-800",
      "ingested"  => "bg-green-100 text-green-800",
      "undone"    => "bg-gray-100 text-gray-800"
    }

    css = colors[status.to_s] || "bg-gray-100 text-gray-800"
    content_tag(:span, status, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{css}")
  end

  def file_type_badge(file_type)
    colors = {
      "Markdown"     => "bg-purple-100 text-purple-800",
      "PDF"          => "bg-red-100 text-red-800",
      "Image (OCR)"  => "bg-teal-100 text-teal-800"
    }

    css = colors[file_type.to_s] || "bg-gray-100 text-gray-800"
    content_tag(:span, file_type, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{css}")
  end
end
