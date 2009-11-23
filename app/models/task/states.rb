class Task
  module States

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
        aasm_state          :rejected

        # editor confirms that task is completed by assignee
        aasm_state          :confirmed

        # editor confirms that task is ready to be published
        aasm_state          :ready_to_publish

        # editor confirms that a child task created (proofing or other task)
        aasm_state          :other_task_created

        validates_presence_of :state
      end
    end

  end
end