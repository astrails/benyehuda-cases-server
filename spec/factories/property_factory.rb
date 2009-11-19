Factory.define :property do |p|
  p.sequence(:title) {|n| "some_#{n}"}
  p.parent_type "Editor"
  p.property_type "string"
end

Factory.define :bool_property, :parent => :property do |p|
  p.property_type "boolean"
end

Factory.define :text_property, :parent => :property do |p|
  p.property_type "text"
end
