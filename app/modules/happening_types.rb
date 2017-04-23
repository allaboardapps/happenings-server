module HappeningTypes
  THEATER = "theater".freeze
  SPORTS = "sports".freeze

  def self.all
    [
      HappeningTypes::THEATER,
      HappeningTypes::SPORTS
    ]
  end
end
