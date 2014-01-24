# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    trait :with_user do
      user
    end

    trait :autofill do
      name { user.try(:login).try(:capitalize) }
      website ['http://19wu.org', 'http://shinebox.cn'].sample
      bio '**Launch your Event today**'
    end
  end
end
