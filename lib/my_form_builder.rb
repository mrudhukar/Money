class MyFormBuilder < ActionView::Helpers::FormBuilder

  helpers = %w{text_field password_field text_area}

  helpers.each do |name|
    define_method(name) do |field_name, *args|
      options = args.extract_options!
      options[:class] ||= ''
      options[:class] << " #{name}"
      options[:title] ||= field_name.to_s.humanize

      field_id = "#{object_name}_#{field_name}"

      # Convert field ids of nested resources like user[professional_profile]_about_me
      # to user_professional_profile_about_me by replacing [ and ] with _
      #
      field_id.gsub!(/[\[\]]/, '_')
      field_id.gsub!(/_+/, '_')

      title_text = options[:title]
      title_text << " *" if options.delete(:required)

      title = ""
      title += label(field_id, title_text.html_safe, :for => field_id) unless options[:skip_title]

      help_text = if options[:help_text]
        @template.content_tag(:span, options[:help_text].html_safe, :class => "help-inline")
      else
        "".html_safe
      end

      input = @template.content_tag(:div, super(field_name, options) + help_text, :class => 'input')

      @template.content_tag(:div, (title + input).html_safe, :class => 'clearfix')
    end
  end

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