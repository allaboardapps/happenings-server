FactoryGirl.define do
  fake_starts_at = Faker::Time.forward(60)
  fake_ends_at = fake_starts_at + [2, 3, 4].sample.hours

  factory :occurrence do
    starts_at fake_starts_at
    ends_at fake_ends_at
    archived false
    test false
    dummy false
  end
end
