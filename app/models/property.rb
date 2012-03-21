class Property < ActiveRecord::Base

  PARENTS = %w(User Volunteer Editor Task Request)
  TYPES = %w(string text boolean)

  validates :title, :parent_type, :property_type, :presence => true
  validates :parent_type, :inclusion => { :in => PARENTS }
  validates :property_type, :inclusion => { :in => TYPES }
  validates :title, :uniqueness => { :scope => :parent_type }

  attr_accessible :title, :parent_type, :property_type, :is_public, :comment

  scope :by_parent_type_and_title, order("properties.parent_type, properties.title")

  PARENTS.each do |parent|
    scope "available_for_#{parent.downcase}".to_sym, lambda {|user| where(available_for_conditions(user), parent) }
  end

  has_many :custom_properties

  private

  def available_for_conditions(user)
    conditions = "properties.parent_type  = ?"
    conditions << " AND properties.is_public = 1" unless user.admin_or_editor?
  end
end
