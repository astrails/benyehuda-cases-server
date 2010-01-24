Factory.define :task do |t|
  t.sequence(:name) {|n| "some_#{n}"}
  t.association :creator, :factory => :admin
  t.association :assignee, :factory => :volunteer
  t.association :editor, :factory => :editor
  t.kind "typing"
  t.difficulty "normal"
  t.parent_id nil
end

Factory.define :assigned_task, :parent => :task do |t|
  t.state "assigned"
end

Factory.define :waits_for_editor_approve_task, :parent => :task do |t|
  t.state "waits_for_editor"
end

