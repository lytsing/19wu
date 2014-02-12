# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    title "shinebox development meeting"
    start_time 8.day.since
    end_time 9.days.since
    location "Tianjin, China"
    content "Contents here"
    slug "rubyconfchina"
    user

    trait :finished do
      start_time 8.day.ago
      end_time 7.days.ago
    end

    trait :markdown do
      content <<-MD
# Awesome Course #

-   free wifi
-   free coffee
      MD
      location_guide <<-MD
subway line 2, foo station
      MD
    end
  end
end
