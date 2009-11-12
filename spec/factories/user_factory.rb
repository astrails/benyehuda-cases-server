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
