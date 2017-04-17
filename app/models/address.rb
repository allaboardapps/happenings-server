class Address < ApplicationRecord
  include Activatable

  belongs_to :author, class_name: "User", foreign_key: :author_id

  # Creates an address instance for test/dev needs
  #
  # @param user [Object] a user instance
  # @param dummy [Boolean] default is `true`
  # @return [Object] the newly created address instance with `dummy` set to `true`
  #
  # @example Create a seed instance of an address with dummy trait
  #   Address.seed #=> address
  #   address.dummy #=> true
  def self.seed(user:, dummy: true)
    address_attrs = {
      author: user,
      name: Faker::Company.name,
      abbreviation: Faker::Lorem.characters.upcase,
      description: Faker::Lorem.sentence(10),
      accessibility_info: Faker::Lorem.sentence(10),
      address_1: Faker::Address.street_name,
      address_2: Faker::Address.secondary_address,
      space: Faker::Lorem.sentence(3),
      city: Faker::Address.city,
      state: Faker::Address.state_abbr,
      zip_code: Faker::Address.zip_code,
      country: Faker::Address.country_code,
      latitude: Faker::Address.latitude,
      longitude: Faker::Address.longitude,
      time_zone: Faker::Address.time_zone,
      phone_number: Faker::PhoneNumber.phone_number,
      website_url: Faker::Internet.url,
      admin_notes: Faker::Lorem.sentence(10),
      archived: false,
      test: false,
      dummy: dummy
    }

    address = new(address_attrs)
    address.save!
    address
  end
end
