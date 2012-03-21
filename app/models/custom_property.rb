class CustomProperty < ActiveRecord::Base
  belongs_to :proprietary, :polymorphic => true
  belongs_to :property

  validates :property_id, :proprietary_id, :proprietary_type, :presence => true

  validates :property_id, :uniqueness => { :scope => [:proprietary_id, :proprietary_type] }

  attr_accessible :property_id, :custom_value

  scope :visible_for, lambda { |user|
    user.admin_or_editor? ? where("") : where("properties.is_public = 1")
  }
end
