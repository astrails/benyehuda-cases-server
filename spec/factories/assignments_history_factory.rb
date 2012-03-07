Factory.define :assignment_history do |a|
  a.association :user, :factory => :admin
  a.association :task, :factory => :task
end