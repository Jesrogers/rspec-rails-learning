FactoryBot.define do
  factory :user do
    first_name "Jesse"
    last_name "Rogers"
    sequence(:email) { |n| "example#{n}@gmail.com" }
    password "crazy-complex-password"
  end
end
