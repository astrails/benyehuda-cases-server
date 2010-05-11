module Task::States

  def self.included(base)
    base.class_eval do
      include AASM

      aasm_column :state

      # somebody has to start working on it
      aasm_state          :unassigned

      # assigned to assignee and edtior
      aasm_state          :assigned

      # assignee is stuck and need editor's help
      aasm_state          :stuck

      # assignee work in progress, and partially ready
      aasm_state          :partial

      # assignee complete the work
      aasm_state          :waits_for_editor

      # editor rejects the task, assignee should fix whatever is done wrong
      aasm_state          :rejected

      # editor confirms that task is completed by assignee
      aasm_state          :approved

      # editor confirms that task is ready to be published
      aasm_state          :ready_to_publish

      # editor confirms that a child task created (proofing or other task)
      aasm_state          :other_task_creat

      validates_presence_of :state
      validates_presence_of :assignee, :editor, :if => :should_have_assigned_peers?, :on => :update

      # assign a task to new assignee
      aasm_event :_assign do
        transitions :from => [:unassigned, :assigned], :to => :assigned
        transitions :from => :waits_for_editor, :to => :waits_for_editor
        transitions :from => :confirmed, :to => :confirmed
        transitions :from => :other_task_creat, :to => :other_task_creat
        transitions :from => :approved, :to => :approved
        transitions :from => :ready_to_publish, :to => :ready_to_publish
        transitions :from => :stuck, :to => :stuck
        transitions :from => :partial, :to => :partial
        transitions :from => :rejected, :to => :rejected
      end
      protected :_assign, :_assign!

      # reject assignment
      aasm_event :_abandon do
        transitions :from => [:assigned, :stuck, :partial, :rejected, :confirmed], :to => :unassigned
      end
      protected :_abandon, :_abandon!

      # assignee needs editor's help
      aasm_event :help_required do
        transitions :from => [:assigned, :partial, :rejected], :to => :stuck
      end

      # assignee finished partially her work
      aasm_event :finish_partially do
        transitions :from => [:assigned, :stuck, :partial, :rejected], :to => :partial
      end

      # assignee finished the work
      aasm_event :finish do
        transitions :from => [:assigned, :stuck, :partial, :rejected], :to => :waits_for_editor
      end

      # editor approves the work
      aasm_event :approve do
        transitions :from => :waits_for_editor, :to => :approved
      end

      # editor rejects the work
      aasm_event :_reject do
        transitions :from => :waits_for_editor, :to => :rejected
      end
      protected :_reject, :_reject!

      # edtior, admin marks as ready to publish
      aasm_event :complete do
        transitions :from => [:approved, :other_task_creat], :to => :ready_to_publish
      end

      aasm_event :create_other_task do
        transitions :from => [:approved, :ready_to_publish, :other_task_creat], :to => :other_task_creat
      end
      before_validation_on_create :pre_process_parent_task
      after_create :post_process_parent_task

      named_scope :visible_in_my_tasks, {:conditions => "tasks.state NOT IN ('ready_to_publish', 'other_task_creat')"}

      has_reason_comment :_reject, :rejection, :editor, N_("Task rejected")
      has_reason_comment(:_abandon, :abandoning, :assignee, N_("Task abandoned")) do |task, opts|
        task.assignee = nil
      end

      has_reason_comment(:finish, :finished, :assignee, N_("Task finished")) do |task, request_new_task|
        task.assignee.set_task_requested! if request_new_task.to_bool
      end
    end
  end

  def request_new_task
    true # always ask for new task when this one is done - default value
  end

  def should_have_assigned_peers?
    !unassigned?
  end

  def assign_editor(new_editor)
    self.editor = new_editor
    _assign
  end

  def assign_assignee(new_assignee)
    self.assignee = new_assignee
    if assignee_id_changed? && new_assignee
      new_assignee.task_requested_at = nil
      new_assignee.save
    end
    _assign
  end

  def assign!(new_editor = nil, new_assignee = nil)
    assign_editor(new_editor)
    assign_assignee(new_assignee)
    save!
  end

  def assign_by_user_ids!(new_editor_id, new_assignee_id)
    assign!(User.all_editors.find_by_id(new_editor_id.to_i), User.all_volunteers.find_by_id(new_assignee_id.to_i))
  end

  def abandon
    self.assignee = nil
    _abandon
  end

  def pre_process_parent_task
    return if parent_id.blank?

    begin
      parent.create_other_task
      parent.save!
    rescue AASM::InvalidTransition, ActiveRecord::RecordInvalid
      @parent_task_cannot_be_updated = true
    end

    if self.comments.first
      self.comments.first.user_id = self.creator_id
    end
  end

  def clone_parent_documents
    parent.documents.each do |doc|
      d = doc.clone
      d.task_id = self.id
      d.file = doc.file.to_file
      d.save
    end
  end

  def clone_children_comments
    return unless comment = comments.first
    c = comment.clone
    c.task_id = parent_id
    c.save
  end

  def post_process_parent_task
    return if parent_id.blank?
    clone_parent_documents
    clone_children_comments
  end

  def build_chained_task(opts, actor) # opts -> name, kind, difficulty, full_nikkud
    new_task = Task.new(opts)
    new_task.editor = new_task.creator = actor
    new_task.parent_id = self.id
    new_task
  end

  def simple_assignee_events
    aasm_events_for_current_state.collect(&:task_event_cleanup) & ["help_required", "finish_partialy"]
  end

  def can_be_finished?
    aasm_events_for_current_state.member?(:finish)
  end

  def simple_editor_events
    aasm_events_for_current_state.collect(&:task_event_cleanup) & ["approve", "complete"]
  end

  def can_be_rejected?
    aasm_events_for_current_state.member?(:_reject)
  end

  def can_be_abandoned?
    aasm_events_for_current_state.member?(:_abandon)
  end

  def can_create_new_task?
    aasm_events_for_current_state.member?(:create_other_task)
  end

  def admin_state
    state
  end

  def admin_state=(value)
    self.state = value
  end

  EDITOR_EVENTS = [:reject, :complete, :create_other_task, :approve]
  ASSIGNEE_EVENTS = [:abandon, :finish, :help_required, :finish_partially]

  def allow_event_for?(event, user)
    return false if event.blank?
    return false unless user.is_admin? || participant?(user)
    return false unless Task.aasm_events.collect(&:first).collect(&:task_event_cleanup).member?(event.to_s)

    return true if assignee?(user) && ASSIGNEE_EVENTS.member?(event.to_sym)
    return true if editor?(user) && EDITOR_EVENTS.member?(event.to_sym)

    false
  end  
end
