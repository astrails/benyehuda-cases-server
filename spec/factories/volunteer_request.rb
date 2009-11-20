Factory.define :volunteer_request do |volunteer_request|
  volunteer_request.sequence(:reason) {|n| "Some reason #{n}"}
  volunteer_request.association :user, :factory => :active_user
end

Factory.define :confirmed_volunteer_request, :parent => :volunteer_request do |user|
  user.approved_at 1.month.ago.utc
end
