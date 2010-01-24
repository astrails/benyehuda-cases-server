class Task < ActiveRecord::Base

  belongs_to :creator, :class_name => "User"
  belongs_to :editor, :class_name => "User"
  belongs_to :assignee, :class_name => "User"

  belongs_to :parent, :class_name => "Task"
  has_many   :children, :class_name => "Task", :foreign_key => "parent_id"

  include CustomProperties
  has_many_custom_properties :task # task_properties

  include CommentWithReason
  include Task::States

  validates_presence_of :creator_id
  validates_presence_of :name

  KINDS = %w(typing proofing other)
  validates_presence_of :kind
  validates_inclusion_of :kind, :in => KINDS, :message => "not included in the list"

  DIFFICULTIES = %w(easy normal hard)
  validates_presence_of :difficulty
  validates_inclusion_of :difficulty, :in => DIFFICULTIES, :message => "not included in the list"

  attr_accessible :name, :kind, :difficulty, :full_nikkud

  named_scope :by_updated_at, :order => "tasks.updated_at"

  has_many :comments, :order => "comments.task_id, comments.created_at"

  include DefaultAttributes
  default_attribute :kind, "typing"
  default_attribute :difficulty, "normal"

  has_many :documents, :dependent => :destroy, :conditions => "documents.deleted_at IS NULL"

  def validate
    errors.add(:base, _("task cannot be updated")) if @parent_task_cannot_be_updated
  end

  def participant?(user)
    return false unless user
    [creator_id, editor_id, assignee_id].member?(user.id)
  end

  def assignee?(user)
    return assignee && user && user.id == assignee.id
  end

  def editor?(user)
    return editor && user && user.id == editor.id
  end
end
