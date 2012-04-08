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

VolunteerKind.delete_all
VolunteerKind.create(
  [
    {:name => "סריקה"},
    {:name => "עריכה טכנית"},
    {:name => "רשות פרסום"}
  ]
)

TaskState.delete_all
TaskState.create(
  [
    {:name => "unassigned", :value => N_("task state|Unassigned")},
    {:name => "assigned", :value => N_("task state|Assigned/Work in Progress")},
    {:name => "stuck", :value => N_("task state|Editors Help Required")},
    {:name => "partial", :value => N_("task state|Partialy Ready")},
    {:name => "waits_for_editor", :value => N_("task state|Waits for Editor's approvement")},
    {:name => "rejected", :value => N_("task state|Rejected by Editor")},
    {:name => "approved", :value => N_("task state|Approved by Editor")},
    {:name => "ready_to_publish", :value => N_("task state|Ready to Publish")},
    {:name => "other_task_creat", :value => N_("task state|Another Task Created")}
  ]
)
