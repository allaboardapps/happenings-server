FactoryGirl.define do
  fake_password = Faker::Internet.password

  factory :user do
    email { Faker::Internet.email }
    password fake_password
    password_confirmation fake_password
    confirmed_at Time.current
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    time_zone AllowedTimeZones::CENTRAL
    zip_code Faker::Address.zip_code
    archived false
    test false
    dummy false
    roles [UserRoles::CUSTOMER]
    statuses [UserStatuses::BASIC]
  end
end
