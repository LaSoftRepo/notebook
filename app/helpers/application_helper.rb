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

  def center(&block)
    content_tag(:div, capture(&block), class: 'col-sm-8 offset-sm-2 col-md-6 offset-md-3 col-lg-4 offset-lg-4')
  end

  def box(options = {}, &block)
    title, button_text, button_link = options[:title], options[:button_text], options[:button_link]

    if title.present?
      title_tag = content_tag :div, title, class: 'title'
    end

    if button_text.present?
      link_tag = link_to(button_text, button_link, class: 'btn btn-primary')
      button_tag = content_tag :div, link_tag, class: 'button'
    end

    top_box = content_tag(:div, title_tag + button_tag, id: 'top-box')
    content_box = content_tag(:div, capture(&block), id: 'content-box')
    content_tag(:div, (top_box + content_box).html_safe, id: 'box')
  end
end
