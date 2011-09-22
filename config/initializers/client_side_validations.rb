# ClientSideValidations Initializer

require 'client_side_validations/simple_form' if defined?(::SimpleForm)
require 'client_side_validations/formtastic'  if defined?(::Formtastic)

# Uncomment the following block if you want each input field to have the validation messages attached.
 ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
   unless html_tag =~ /^<label/
     %{#{html_tag}<span class="help-block" style="color:#9D261D">#{instance.error_message.first}</span>}.html_safe
   else
     html_tag.html_safe
   end
 end

module ClientSideValidations
  module MyFormBuilder
    module FormBuilder

      def self.included(base)
        base.class_eval do
          def self.client_side_form_settings(options, form_helper)
            {
              :type => self.to_s,
              :error_class => "help-block",
              :error_tag => "span",
              :wrapper_error_class => "error"
            }
          end
        end
      end

    end
  end
end

MyFormBuilder.send(:include, ClientSideValidations::MyFormBuilder::FormBuilder)