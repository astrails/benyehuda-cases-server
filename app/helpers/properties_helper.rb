module PropertiesHelper
  def custom_properties_fields(f, property_parent)
    property_parent = property_parent.to_s.downcase
    association_name = "#{property_parent}_properties"

    Property.send("available_for_#{property_parent}").each do |property|
      haml_concat render(:partial => "layouts/properties_form", :locals => {:f => f, :property => property, :association_name => association_name})
    end
  end
end
