FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Jesse"
    last_name "Rogers"
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password "crazy-complex-password"

    trait :with_project do
      after(:create) { |user| create_list(:project, 1, owner: user, name: "Test Project")}
    end
  end
end
