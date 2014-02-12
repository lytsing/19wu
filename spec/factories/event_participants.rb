# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_participant do
    user_id 1
    course_id 1
    trait :random_user do
      user
    end
  end
end
