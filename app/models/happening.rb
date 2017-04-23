class Happening < ApplicationRecord
  include Activatable

  belongs_to :author, class_name: "User", foreign_key: :author_id
  has_many :occurrences

  # Creates a happening instance for test/dev needs
  #
  # @param author [Object] a User instance
  # @param dummy [Boolean] default is `true`
  # @return [Object] the newly created address instance with `dummy` set to `true`
  #
  # @example Create a seed instance of an address with dummy trait
  #   Happening.seed #=> happening
  #   happening.dummy #=> true
  def self.seed(author:, dummy: true)
    happening_attrs = {
      happening_type: HappeningTypes::THEATER,
      author: author,
      name: Faker::Company.name,
      abbreviation: Faker::Lorem.characters(4).upcase,
      description: Faker::Lorem.sentence(10),
      admin_notes: Faker::Lorem.sentence(10),
      archived: false,
      test: false,
      dummy: dummy
    }

    happening = new(happening_attrs)
    happening.save!
    happening
  end
end
