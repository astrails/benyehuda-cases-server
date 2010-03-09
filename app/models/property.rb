class Property < ActiveRecord::Base

  PARENTS = %w(User Volunteer Editor Task)
  TYPES = %w(string text boolean)

  validates_presence_of :title
  validates_presence_of :parent_type
  validates_presence_of :property_type
  validates_inclusion_of :parent_type, :in => PARENTS
  validates_inclusion_of :property_type, :in => TYPES

  validates_uniqueness_of :title, :scope => [:parent_type]

  attr_accessible :title, :parent_type, :property_type, :is_public, :comment

  named_scope :by_parent_type_and_title, {:order => "properties.parent_type, properties.title"}

  PARENTS.each do |parent|
    named_scope "available_for_#{parent.downcase}".to_sym, lambda {|user|
      conditions = ["properties.parent_type  = ?", parent]

      conditions.first << " AND properties.is_public = 1" unless user.admin_or_editor?

      {:conditions => conditions}
    }
  end

  has_many :custom_properties
end
