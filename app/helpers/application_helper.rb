module ApplicationHelper
  def full_title(page_title)
    base_title = 'Repeek'
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def title(text, args = {})
    [:title, :head_title].each { |i| provide i, text }
    add_breadcrumb text if args[:last_breadcrumb]
  end

  def head_title(text)
    provide :head_title, text
  end

  def box(&block)
    spacer  = content_tag(:div, '', class: 'mdl-layout-spacer')
    content = content_tag(:div, capture(&block), class: 'box mdl-cell mdl-cell--9-col mdl-shadow--2dp')

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

  def add_round_button(args = {})
    mini = args[:mini] ? 'mdl-button--mini-fab' : ''
    klass = "add-round-button #{mini} mdl-button mdl-js-ripple-effect mdl-js-button mdl-button--fab mdl-color--accent"

    link_to args[:link], class: klass do
      raw(
        '<i class="material-icons mdl-color-text--white" role="presentation">add</i>' +
        '<span class="visuallyhidden">add</span>' +
        '<span class="mdl-button__ripple-container">' +
          '<span class="mdl-ripple is-animating"></span>' +
        '</span>'
      )
    end
  end
end
