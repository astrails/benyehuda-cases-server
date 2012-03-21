class VolunteerRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :approver, :class_name => "User"

  validates :user_id, :presence => true
  validates :preferences, :length => { :within => 8..4096 }

  attr_accessible :preferences

  scope :pending, where("volunteer_requests.approved_at is NULL")
  scope :by_request_time, order("volunteer_requests.created_at")
  scope :with_user, includes(:user)

  include CustomProperties
  has_many_custom_properties :request # task_properties

  def approve!(approver_user)
    self.approver = approver_user
    self.approved_at = Time.now.utc
    save!
    self.user.is_volunteer = true
    self.user.save!
  end
end
