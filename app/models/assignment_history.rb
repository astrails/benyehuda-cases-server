class AssignmentHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  validates_presence_of :user_id, :task_id, :role

  attr_accessible :all

  named_scope :recent, lambda { |limit| {:limit => limit} }
  named_scope :with_task, {:include => :task}
  named_scope :reverse_order, {:order => "id DESC"}

  ROLES = {
    "assignee" => N_("Assignee"),
    "creator" => N_("Areator"),
    "editor" => N_("Editor")
  }

  def role_txt
    s_(ROLES[role])
  end
end
