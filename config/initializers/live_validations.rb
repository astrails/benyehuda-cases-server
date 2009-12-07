LiveValidations.use :jquery_validations, :default_valid_message => "", :validate_on_blur => true, 
  :validator_settings => {
    :errorElement => "p", :errorClass => "inline-error",
    :highlight => "function(element, errorClass){jQuery(element).parent('li').addClass('error')}",
    :unhighlight => "function(element, errorClass){jQuery(element).parent('li').removeClass('error')}"
  }
