Factory.define :user do |user|
  user.sequence(:name) {|n| "Name#{n}"}

  user.email {|a| "#{a.name}@example.com".downcase }

  user.password              'qweqwe'
  user.password_confirmation 'qweqwe'

  user.skip_session_maintenance true
end

Factory.define :active_user, :parent => :user do |user|
  user.activated_at 1.month.ago.utc
end

Factory.define :admin, :parent => :active_user do |user|
  user.is_admin true
end

Factory.define :other_admin, :parent => :admin do |user|
end

Factory.define :editor, :parent => :active_user do |user|
  user.is_editor true
end

Factory.define :another_editor, :parent => :editor do |user|
end

Factory.define :volunteer, :parent => :active_user do |user|
  user.is_volunteer true
end

Factory.define :another_volunteer, :parent => :volunteer do |user|
end
