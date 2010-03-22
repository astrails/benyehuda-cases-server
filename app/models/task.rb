class Task < ActiveRecord::Base
  include ActsAsAuditable
  acts_as_auditable :name, :state, :creator_id, :editor_id, :assignee_id, :kind, :difficulty,
    :conversions => {
      :creator_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :editor_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :assignee_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :default_title => N_("auditable|Task")
    }

  belongs_to :creator, :class_name => "User"
  belongs_to :editor, :class_name => "User"
  belongs_to :assignee, :class_name => "User"

  belongs_to :parent, :class_name => "Task"
  has_many   :children, :class_name => "Task", :foreign_key => "parent_id"

  has_many :task_audits, :class_name => "Audit"

  include CustomProperties
  has_many_custom_properties :task # task_properties

  include CommentWithReason
  include Task::States
  include Task::Notifications

  validates_presence_of :creator_id
  validates_presence_of :name

  KINDS = %w(typing proofing other)
  validates_presence_of :kind
  validates_inclusion_of :kind, :in => KINDS, :message => "not included in the list"

  DIFFICULTIES = %w(easy normal hard)
  validates_presence_of :difficulty
  validates_inclusion_of :difficulty, :in => DIFFICULTIES, :message => "not included in the list"

  attr_accessible :name, :kind, :difficulty, :full_nikkud, :comments_attributes

  has_many :comments, :order => "comments.task_id, comments.created_at"
  accepts_nested_attributes_for :comments, :allow_destroy => false, :reject_if => proc {|c| c["message"].blank?}
  # validates_associated :comments, :on => :create

  include DefaultAttributes
  default_attribute :kind, "typing"
  default_attribute :difficulty, "normal"

  has_many :documents, :dependent => :destroy, :conditions => "documents.deleted_at IS NULL"

  define_index do
    indexes :name, :sortable => true
    has :created_at
    has :updated_at
    has :full_nikkud, :type => :boolean
    indexes :difficulty, :sortable => true
    indexes :kind, :sortable => true
    indexes :state, :sortable => true
  end
  sphinx_scope(:by_updated_at){{:order => "updated_at DESC"}}

  SEARCH_KEYS = ["state", "difficulty", "kind", "full_nikkud", "query"]
  def self.filter(opts)
    return self.all if (opts.keys & SEARCH_KEYS).blank?

    search_opts = {:conditions => {}, :with => {}}
    search_opts[:conditions][:state] = opts[:state] unless opts[:state].blank?
    search_opts[:conditions][:difficulty] = opts[:difficulty] unless opts[:difficulty].blank?
    search_opts[:conditions][:kind] = opts[:kind] unless opts[:kind].blank?
    search_opts[:with][:full_nikkud] = ("true" == opts[:full_nikkud]) unless opts[:full_nikkud].blank?
    self.search(opts[:query], search_opts).by_updated_at
  end

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

  def prepare_document(uploader, opts)
    doc = self.documents.build(opts)
    doc.user_id = uploader.id
    doc
  end
end
