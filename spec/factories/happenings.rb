FactoryGirl.define do
  factory :happening do
    happening_type HappeningTypes::THEATER
    name Faker::Company.name
    abbreviation Faker::Lorem.characters.upcase
    description Faker::Lorem.sentence(10)
    admin_notes Faker::Lorem.sentence(10)
    archived false
    test false
    dummy false
  end
end
