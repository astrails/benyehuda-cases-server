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
      aasm_state          :waits_for_editor_approve

      # editor rejects the task, assignee should fix whatever is done wrong
      aasm_state          :rejected, :enter => :update_rejection

      # editor confirms that task is completed by assignee
      aasm_state          :approved

      # editor confirms that task is ready to be published
      aasm_state          :ready_to_publish

      # editor confirms that a child task created (proofing or other task)
      aasm_state          :other_task_created

      validates_presence_of :state
      validates_presence_of :assignee, :editor, :if => :should_have_assigned_peers?, :on => :update

      # assign a task to new assignee
      aasm_event :_assign do
        transitions :from => [:unassigned, :assigned, :stuck, :partial, :waits_for_editor_approve, :rejected, :confirmed], :to => :assigned
      end
      protected :_assign, :_assign!

      # reject assignment
      aasm_event :_abandon do
        transitions :from => [:assigned, :stuck, :partial, :waits_for_editor_approve, :rejected, :confirmed], :to => :unassigned
      end
      protected :_abandon, :_abandon!

      # assignee needs editor's help
      aasm_event :help_required do
        transitions :from => [:assigned, :stuck, :partial, :rejected], :to => :stuck
      end

      # assignee finished partially her work
      aasm_event :finish_partially do
        transitions :from => [:assigned, :stuck, :partial, :rejected], :to => :partial
      end

      # assignee finished the work
      aasm_event :finish do
        transitions :from => [:assigned, :stuck, :partial, :rejected], :to => :waits_for_editor_approve
      end

      # editor approves the work
      aasm_event :approve do
        transitions :from => :waits_for_editor_approve, :to => :approved
      end

      # editor rejects the work
      aasm_event :_reject do
        transitions :from => :waits_for_editor_approve, :to => :rejected
      end
      protected :_reject, :_reject!
      attr_accessor   :rejection_reason
      attr_accessible :rejection_reason

      # edtior, admin marks as ready to publish
      aasm_event :complete do
        transitions :from => [:approved, :other_task_created], :to => :ready_to_publish
      end

      aasm_event :create_other_task do
        transitions :from => [:approved, :ready_to_publish], :to => :other_task_created
      end
    end
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

  def abandon!
    self.assignee = nil
    _abandon!
  end

  def reject!(reason)
    self.rejection_reason = reason
    _reject!
  end
  def update_rejection
    # TODO: create a comment with rejection reason
  end

  def build_chained_task(opts) # opts -> name, kind, difficulty, full_nikkud
    new_task = self.build_child(opts)
    new_task.creator = actor
    new_task.parent_id = self.id
    create_other_task
    # TODO: move all attachments to new task
    new_task
  end
end
