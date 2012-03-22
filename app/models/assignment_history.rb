class AssignmentHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates :user_id, :task_id, :role, :presence => true

  attr_accessible :user_id, :task_id, :role

  scope :recent, lambda { |l| limit(l) }
  scope :with_task, includes(:task)
  scope :reverse_order, order("id DESC")

  ROLES = {
    "assignee" => N_("Assignee"),
    "creator" => N_("Creator"),
    "editor" => N_("Editor")
  }

  def role_txt
    s_(ROLES[role])
  end
end
