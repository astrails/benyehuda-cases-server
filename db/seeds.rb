# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

GlobalPreference.set!('domain', 'dev.tanin:3000')
GlobalPreference.set!('disable_volunteer_notifications', "false")

VolunteerKind.create(
  [
    {:name => "סריקה"},
    {:name => "עריכה טכנית"},
    {:name => "רשות פרסום"}
  ]
)

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

TASK_STATES.each do |k, v|
  TaskState.create(:name => k, :value => v)
end
