FactoryGirl.define do
  fake_starts_at = Time.current
  fake_ends_at = fake_starts_at + (1..3).hours

  factory :occurrences do
    starts_at fake_starts_at
    ends_at fake_ends_at
    archived false
    test false
    dummy false
  end
end
