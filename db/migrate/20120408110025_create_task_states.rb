class CreateTaskStates < ActiveRecord::Migration
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

  def self.up
    create_table :task_states do |t|
      t.string :name
      t.string :value
      t.timestamps
    end

    TASK_STATES.each do |k, v|
      TaskState.create(:name => k, :value => v)
    end
  end

  def self.down
    drop_table :task_states
  end
end
