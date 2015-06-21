module ApplicationHelper
  def page_title(title)
    base_title = "raspas"
    if title.blank?
      base_title
    else
      "#{base_title} | #{title}"
    end
  end

  def disable(message, options = {})
    options.reverse_merge!(scope: 'views.generic')
    t message, options
  end
end
