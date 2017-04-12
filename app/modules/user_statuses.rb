module UserStatuses
  BASIC = "basic".freeze
  NA = "not applicable".freeze
  PRO = "pro".freeze
  PREMIUM = "premium".freeze

  def self.all
    [UserStatuses::BASIC, UserStatuses::NA, UserStatuses::PRO, UserStatuses::PREMIUM]
  end
end
