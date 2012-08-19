class Task < ActiveRecord::Base
  include ActsAsAuditable
  acts_as_auditable :name, :state, :creator_id, :editor_id, :assignee_id, :kind, :difficulty, :full_nikkud,
    :conversions => {
      :creator_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :editor_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :assignee_id => proc { |v| v ? (User.find_by_id(v).try(:name)) : "" },
      :kind => proc {|v| Task.textify_kind(v) },
      :difficulty => proc {|v| Task.textify_difficulty(v) },
      :state => proc {|v| Task.textify_state(v) },
      :full_nikkud => proc {|v| v ? _("true") : _("false")},
      :default_title => N_("auditable|Task"),
      :attributes => proc { |a|
        case a
        when :name
          _("Name")
        when :state
          _("State")
        when :creator_id
          _("Creater")
        when :editor_id
          _("Editor")
        when :assignee_id
          _("Assignee")
        when :kind
          _("Kind")
        when :difficulty
          _("Difficulty")
        when :full_nikkud
          _("Full Nikkud")
        end
      }
    }

  belongs_to :creator, :class_name => "User"
  belongs_to :editor, :class_name => "User"
  belongs_to :assignee, :class_name => "User"

  belongs_to :parent, :class_name => "Task"
  has_many   :children, :class_name => "Task", :foreign_key => "parent_id"

  has_many :task_audits, :class_name => "Audit", :dependent => :destroy

  has_many :assignment_histories, :dependent => :destroy

  include CustomProperties
  has_many_custom_properties :task # task_properties

  include CommentWithReason
  include Task::States
  include Task::Notifications

  validates_presence_of :creator_id
  validates_presence_of :name

  KINDS = {
    "typing" => N_("task kind|typing"),
    "proofing" => N_("task kind|proofing"),
    "other" => N_("task kind|other")
  }
  validates_presence_of :kind
  validates_inclusion_of :kind, :in => KINDS.keys, :message => "not included in the list"

  DIFFICULTIES = {
    "easy" => N_("task difficulty|easy"),
    "normal" => N_("task difficulty|normal"),
    "hard" => N_("task difficulty|hard")
  }
  
  validates_presence_of :difficulty
  validates_inclusion_of :difficulty, :in => DIFFICULTIES.keys, :message => "not included in the list"

  attr_accessible :name, :kind, :difficulty, :full_nikkud, :comments_attributes

  has_many :comments, :order => "comments.task_id, comments.created_at"
  accepts_nested_attributes_for :comments, :allow_destroy => false, :reject_if => proc {|c| c["message"].blank?}
  # validates_associated :comments, :on => :create

  include DefaultAttributes
  default_attribute :kind, "typing"
  default_attribute :difficulty, "normal"

  has_many :documents, :dependent => :destroy, :conditions => "documents.deleted_at IS NULL"

  after_save :update_assignments_history
  def update_assignments_history    
    assignee.assignment_histories.create(:task_id => self.id, :role => "assignee") if assignee_id_changed? && !assignee.blank?
    
    editor.assignment_histories.create(:task_id => self.id, :role => "editor") if editor_id_changed? && !editor.blank?
    
    creator.assignment_histories.create(:task_id => self.id, :role => "creator") if creator_id_changed? && !creator.blank?
  end

  define_index do
    indexes :name, :sortable => true
    has :created_at
    has :updated_at
    has :full_nikkud, :type => :boolean
    indexes :difficulty, :sortable => true
    indexes :kind, :sortable => true
    indexes :state, :sortable => true
    has :documents_count, :type => :integer
  end
  sphinx_scope(:by_updated_at){{:order => "updated_at DESC"}}

  SEARCH_INCLUDES = {
    :include => [:creator, :assignee, :editor]
  }

  TASK_LENGTH = {
    "short" => 0..7,
    "medium" => 8..24,
  }
  TASK_LENGTH.default = 25..100000000

  SEARCH_KEYS = ["state", "difficulty", "kind", "full_nikkud", "query", "length"]
  def self.filter(opts)
    return self.all.paginate(:page => opts[:page], :per_page => opts[:per_page]) if (opts.keys & SEARCH_KEYS).blank?

    search_opts = {:conditions => {}, :with => {}}
    search_opts[:conditions][:state] = opts[:state] unless opts[:state].blank?
    search_opts[:conditions][:difficulty] = opts[:difficulty] unless opts[:difficulty].blank?
    search_opts[:conditions][:kind] = opts[:kind] unless opts[:kind].blank?
    search_opts[:with][:full_nikkud] = ("true" == opts[:full_nikkud]) unless opts[:full_nikkud].blank?
    unless opts[:length].blank?
      search_opts[:with][:documents_count] = TASK_LENGTH[opts[:length]]
    end
    if opts[:query].blank?
      self.find(:all, SEARCH_INCLUDES.merge(:order => "updated_at DESC").merge(:conditions => search_opts[:conditions].merge(search_opts[:with]))).paginate(:page => opts[:page], :per_page => opts[:per_page])
    else
      self.search(opts[:query], search_opts.merge(SEARCH_INCLUDES).merge(:page => opts[:page], :per_page => opts[:per_page])).by_updated_at
    end
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

  ######### i18 n
  def self.textify_kind(kind)
    s_(KINDS[kind]) if KINDS[kind]
  end

  def self.textify_difficulty(dif)
    s_(DIFFICULTIES[dif]) if DIFFICULTIES[dif]
  end

  TASK_STATES = {
    "unassigned" => N_("task state|Unassigned"),
    "assigned" => N_("task state|Assigned/Work in Progress"),
    "stuck" => N_("task state|Editors Help Required"),
    "partial" => N_("task state|Partialy Ready"),
    "waits_for_editor" => N_("task state|Waits for Editor's approvement"),
    "rejected" => N_("task state|Rejected by Editor"), 
    "approved" => N_("task state|Approved by Editor"),
    "ready_to_publish" => N_("task state|Ready to Publish"),
    "other_task_creat" => N_("task state|Another Task Created")
  }

  def self.textify_state(state)
    s_(TASK_STATES[state.to_s]) if TASK_STATES[state.to_s]
  end
  
end
