class VolunteerRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :approver, :class_name => "User"

  validates_presence_of :user_id
  validates_length_of :reason, :within => 8..4096

  attr_accessible :reason
end
