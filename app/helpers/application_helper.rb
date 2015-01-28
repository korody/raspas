module ApplicationHelper
  def page_title(title)
    base_title = "COMPANYNAME Identity"
    if title.blank?
      base_title
    else
      "#{base_title} - #{title}"
    end
  end
end
