FactoryGirl.define do
  factory :user, aliases: %i[admin staff customer] do
    email { Faker::Internet.email }
    password { "ThisShouldWork1" }
    password_confirmation { "ThisShouldWork1" }
    confirmed_at Time.current
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    time_zone { AllowedTimeZones::CENTRAL }
    archived false
    test false
    dummy false
    roles { [UserRoles::CUSTOMER] }

    trait :admin do
      roles { [UserRoles::ADMIN] }
    end

    trait :staff do
      roles { [UserRoles::STAFF] }
    end

    trait :customer do
      roles { [UserRoles::CUSTOMER] }
    end

    trait :basic do
      statuses { [UserStatuses::BASIC] }
    end

    trait :pro do
      statuses { [UserStatuses::PRO] }
    end

    trait :premium do
      statuses { [UserStatuses::PREMIUM] }
    end

    trait :archived do
      archived true
    end

    trait :test do
      test true
    end

    trait :dummy do
      dummy true
    end
  end
end
