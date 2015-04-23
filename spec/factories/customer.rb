FactoryGirl.define do
  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    email Faker::Internet.email
    date_of_birth Date.new(1989, 12, 7)
    gender 'male'
  end
end
