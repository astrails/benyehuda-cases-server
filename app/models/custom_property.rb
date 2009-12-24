class CustomProperty < ActiveRecord::Base
  belongs_to :proprietary, :polymorphic => true
  belongs_to :property

  validates_presence_of :property_id
  validates_presence_of :proprietary_id
  validates_presence_of :proprietary_type

  validates_uniqueness_of :property_id, :scope => [:proprietary_id, :proprietary_type]
  
  attr_accessible :property_id, :custom_value

  named_scope :visible_for, lambda { |user|
    user.admin_or_editor? ? {} : {:conditions => "properties.is_public = 1"}
  }
end
