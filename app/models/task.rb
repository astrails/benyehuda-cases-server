class Task < ActiveRecord::Base

  belongs_to :creator, :class_name => "User"
  belongs_to :editor, :class_name => "User"
  belongs_to :assignee, :class_name => "User"

  belongs_to :parent, :class_name => "Task"
  has_one    :child, :class_name => "Task", :foreign_key => "child_id"

  include CustomProperties
  has_many_custom_properties :task # task_properties

  include Task::States

  validates_presence_of :creator_id
  validates_presence_of :name

  KINDS = %w(typing proofing other)
  validates_presence_of :kind
  validates_inclusion_of :kind, :in => KINDS, :message => "not included in the list"

  DIFFICULTIES = %w(easy normal hard)
  validates_presence_of :difficulty
  validates_inclusion_of :difficulty, :in => DIFFICULTIES, :message => "not included in the list"

  attr_accessible :name, :difficulty, :full_nikkud
end
