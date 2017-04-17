FactoryGirl.define do
  factory :address do
    name Faker::Company.name
    abbreviation Faker::Lorem.characters.upcase
    description Faker::Lorem.sentence(10)
    accessibility_info Faker::Lorem.sentence(10)
    address_1 Faker::Address.street_name
    address_2 Faker::Address.secondary_address
    space Faker::Lorem.sentence(3)
    city Faker::Address.city
    state Faker::Address.state_abbr
    zip_code Faker::Address.zip_code
    country Faker::Address.country_code
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude
    time_zone Faker::Address.time_zone
    phone_number Faker::PhoneNumber.phone_number
    website_url Faker::Internet.url
    admin_notes Faker::Lorem.sentence(10)
    archived false
    test false
    dummy false
  end
end
