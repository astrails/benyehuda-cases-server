class VolunteerRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :approver, :class_name => "User"

  validates_presence_of :user_id
  validates_length_of :reason, :within => 8..4096

  attr_accessible :reason

  named_scope :pending, :conditions => "volunteer_requests.approved_at is NULL"
  named_scope :by_request_time, :order => "volunteer_requests.created_at"
  named_scope :with_user, :include => :user

  def approve!(approver_user)
    self.approver = approver_user
    self.approved_at = Time.now.utc
    save!
    self.user.is_volunteer = true
    self.user.save!
  end
end
