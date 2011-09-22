clientSideValidations.formBuilders['MyFormBuilder'] = {
  add: function(element, settings, message) {
    if (element.data('valid') !== false) {
      var inner_wrapper = element.parent();
      var wrapper = inner_wrapper.parent();
      wrapper.addClass(settings.wrapper_error_class);
      var errorElement = jQuery('<' + settings.error_tag + ' class="' + settings.error_class + '">' + message + '</' + settings.error_tag + '>');
      inner_wrapper.append(errorElement);
    } else {
      element.parent().find(settings.error_tag + '.' + settings.error_class).text(message);
    }
  },
  remove: function(element, settings) {
    var wrapper = element.parent().parent();
    wrapper.removeClass(settings.wrapper_error_class);
    var errorElement = wrapper.find(settings.error_tag + '.' + settings.error_class);
    errorElement.remove();
  }
}
