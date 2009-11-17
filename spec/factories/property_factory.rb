Factory.define :property do |p|
  p.sequence(:title) {|n| "some_#{n}"}
  p.parent_type "Editor"
  p.property_type "string"
end
