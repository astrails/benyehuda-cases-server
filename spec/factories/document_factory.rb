Factory.define :document do |t|
  t.association :task, :factory => :task
  t.file_file_size 123
  t.association :user_id, :factory => :volunteer
  t.file_file_name "foobar"
  t.created_at Time.now.utc
end
