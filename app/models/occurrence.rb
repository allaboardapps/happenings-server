class Occurrence < ApplicationRecord
  include Activatable

  belongs_to :happening

  # Creates an occurrence instance for test/dev needs
  #
  # @param happening [Object] a Happening instance
  # @param dummy [Boolean] default is `true`
  # @return [Object] the newly created occurrence instance with `dummy` set to `true`
  #
  # @example Create a seed instance of an occurrence with dummy trait
  #   Occurrence.seed #=> occurrence
  #   occurrence.dummy #=> true
  def self.seed(happening:, dummy: true)
    fake_starts_at = Faker::Time.forward(60)
    fake_ends_at = fake_starts_at + [2, 3, 4].sample.hours

    occurrence_attrs = {
      happening: happening,
      starts_at: fake_starts_at,
      ends_at: fake_ends_at,
      archived: false,
      test: false,
      dummy: dummy
    }

    occurrence = new(occurrence_attrs)
    occurrence.save!
    occurrence
  end
end
