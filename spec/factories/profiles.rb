# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    trait :with_user do
      user
    end

    trait :autofill do
      name { user.try(:login).try(:capitalize) }
      website ['http://shinebox.org', 'http://shinebox.cn'].sample
      bio '**Launch your Course today**'
    end
  end
end
