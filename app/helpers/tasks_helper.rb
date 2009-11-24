module TasksHelper
  TASK_STATES = {
    "unassigned" => "Unassigned",
    "assigned" => "Assigned/Work in Progress",
    "stuck" => "Editors Help Required",
    "partial" => "Partialy Ready",
    "waits_for_editor_approve" => "Waits for Editor's approvement",
    "rejected" => "Rejected by Editor", 
    "approved" => "Approved by Editor",
    "ready_to_publish" => "Ready to Publish",
    "other_task_created" => "Another Task Created"
  }

  def textify_state(state)
    TASK_STATES[state]
  end
end
