class Property < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :parent_type
  validates_presence_of :property_type
  validates_inclusion_of :parent_type, :in => %w(Volunteer Editor Task), :message => "type {{value}} is not included in the list"
  validates_inclusion_of :property_type, :in => %w(string text boolean), :message => "type {{value}} is not included in the list"

  attr_accessible :title, :parent_type, :property_type
end
