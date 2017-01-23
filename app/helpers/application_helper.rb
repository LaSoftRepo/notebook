module ApplicationHelper

  def flash_class_for(flash_type)
    case flash_type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'warning'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type
    end
  end

  def full_title(page_title)
    base_title = 'Repeek'
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end
end
