class Property < ActiveRecord::Base

  PARENTS = %w(Volunteer Editor Task)
  TYPES = %w(string text boolean)

  validates_presence_of :title
  validates_presence_of :parent_type
  validates_presence_of :property_type
  validates_inclusion_of :parent_type, :in => PARENTS, :message => "not included in the list"
  validates_inclusion_of :property_type, :in => TYPES, :message => "not included in the list"

  validates_uniqueness_of :title, :scope => [:parent_type]

  attr_accessible :title, :parent_type, :property_type

  named_scope :by_parent_type, {:order => "properties.parent_type DESC"}
  named_scope :by_title, {:order => "properties.title DESC"}
end
