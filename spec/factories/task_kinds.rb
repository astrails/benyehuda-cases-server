# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :task_kind do |k|
    k.sequence(:name) {|n| "some_kind_#{n}"}
  end
end
