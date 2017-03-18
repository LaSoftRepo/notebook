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

  def box(args = {}, &block)
    # args.reverse_merge!({ button_link: '#', button_data: {}, head_title: true })
    #
    # title = args[:title]
    # button_text = args[:button_text]
    # button_link = args[:button_link]
    # button_data = args[:button_data].merge(class: 'btn btn-primary')
    #
    # if title.present?
    #   title_tag = content_tag :div, title, class: 'title'
    #   # I'm not sure if this is right but it removes a lot of duplications
    #   provide :head_title, title if args[:head_title]
    # end
    #
    # if button_text.present?
    #   link_tag = link_to(button_text, button_link, button_data)
    #   button_tag = content_tag :div, link_tag, class: 'button'
    # end
    #
    # top_box = content_tag(:div, title_tag + button_tag, id: 'top-box')
    # content_box = content_tag(:div, capture(&block), id: 'content-box')
    # content_tag(:div, (top_box + content_box).html_safe, id: 'box')

    # Realization without button

    args.reverse_merge!({ head_title: true })

    title = args[:title]

    if title.present?
      title_tag = content_tag :div, title, class: 'title'
      # I'm not sure if this is right but it removes a lot of duplications
      provide :head_title, title if args[:head_title] == true
    end

    # breadcrumbs = content_tag(:div, render_breadcrumbs(separator: '/'), class: 'breadcrumbs')

    # top_box = content_tag(:div, title_tag + breadcrumbs, id: 'top-box')
    top_box = content_tag(:div, title_tag, id: 'top-box')
    content_box = content_tag(:div, capture(&block), id: 'content-box')
    content_tag(:div, (top_box + content_box).html_safe, id: 'box')
  end
end
