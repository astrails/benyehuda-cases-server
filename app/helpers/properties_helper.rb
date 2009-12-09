module PropertiesHelper
  def custom_properties_fields(f, property_parent)
    property_parent = property_parent.to_s.downcase
    association_name = "#{property_parent}_properties"

    Property.send("available_for_#{property_parent}").each do |property|
      haml_concat render(:partial => "layouts/properties_form", :locals => {:f => f, :property => property, :association_name => association_name})
    end
  end

  def property_input_opts(property, association_name, f)
    std_opts = { :label => h(property.title), :required => false, :as => property.property_type.to_sym }
    value = f.object.send(association_name).indexed_by_id[property.id].try(:custom_value)

    std_opts[:input_html] = if "boolean" == property.property_type
      {:checked => !(value.blank? || value.to_i.zero?)}
    else
      {:value => value}
    end

    std_opts
  end

  def property_value(p)
    if "boolean" == p.property.property_type
      return p.custom_value.to_s == "1" ? "true" : "false"
    end
    p.custom_value
  end
end
