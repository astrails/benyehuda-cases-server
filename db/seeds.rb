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
