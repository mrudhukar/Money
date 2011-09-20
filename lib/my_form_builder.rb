class MyFormBuilder < ActionView::Helpers::FormBuilder

  def submit(label, *args)
    options = args.first || {}
    options[:disable_with] = 'please wait..'
    options[:class] = (options[:class] || '') + 'btn primary'

    super(label, options)
  end

  def actions(&block)
    @template.content_tag(:div, @template.capture(&block), :class => "actions")
  end

end