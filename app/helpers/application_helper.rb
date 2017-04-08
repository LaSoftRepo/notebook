module ApplicationHelper
  def full_title(page_title)
    base_title = 'Repeek'
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def title(text)
    provide :title, text
  end

  def head_title(text)
    provide :head_title, text
  end

  def box(&block)
    spacer  = content_tag(:div, '', class: 'mdl-layout-spacer')
    content = content_tag(:div, capture(&block), class: 'box mdl-cell mdl-cell--9-col mdl-shadow--4dp')

    (spacer + content + spacer).html_safe
  end

  def small_form(args = {}, &block)
    spacer = content_tag(:div, '', class: 'mdl-layout-spacer')
    form   = content_tag(:div, capture(&block))
    title  = content_tag(:h1, args[:title])
    errors = if args[:errors].try(:any?)
      ApplicationController.render(
        partial: 'shared/errors',
        locals: { errors: args[:errors] }
      )
    end

    content = content_tag(
      :div,
      title + errors + form,
      class: 'small-form mdl-cell mdl-cell--4-col mdl-shadow--2dp'
    )

    (spacer + content + spacer).html_safe
  end
end
