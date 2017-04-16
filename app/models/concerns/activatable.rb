module Activatable
  extend ActiveSupport::Concern

  included do
    scope :actives, (-> { where(archived: false, test: false, dummy: false) })
    scope :inactives, (-> { where("archived IS TRUE OR test IS TRUE OR dummy IS TRUE") })
    scope :archives, (-> { where(archived: true) })
    scope :tests, (-> { where(test: true) })
    scope :dummies, (-> { where(dummy: true) })
  end

  # Specifies if user instance is active
  #
  # @return [Boolean]
  #
  # @example Determine that a user is active
  #   user.archived #=> false
  #   user.test #=> false
  #   user.dummy #=> false
  #   user.active? #=> true
  #
  # @example Determine that a user is inactive
  #   user.archived #=> true
  #   user.test #=> false
  #   user.dummy #=> false
  #   user.active? #=> false
  def active?
    !archived && !test && !dummy
  end

  # Sets the model instance attributes to active
  #
  # @return [Boolean]
  #
  # @example Activate a user instance
  #   user.archived #=> true
  #   user.test #=> true
  #   user.dummy #=> true
  #
  #   user.activate! #=> true
  #
  #   user.archived #=> false
  #   user.test #=> false
  #   user.dummy #=> false
  def activate!
    update!(archived: false, test: false, dummy: false)
  end

  # Sets the model instance attribute of `archived` to `true`
  #
  # @return [Boolean]
  #
  # @example Set user instance to archived
  #   user.archived #=> false
  #   user.archive! #=> true
  #   user.archived #=> true
  def archive!
    update!(archived: true)
  end

  # Sets the model instance attribute of `archived` to `false`
  #
  # @return [Boolean]
  #
  # @example Set user instance to active
  #   user.archived #=> true
  #   user.unarchive! #=> true
  #   user.archived #=> false
  def unarchive!
    update!(archived: false)
  end

  # Sets the model instance attribute of `test` to `true`
  #
  # @return [Boolean]
  #
  # @example Set user as test instance
  #   user.test #=> false
  #   user.testify! #=> true
  #   user.test #=> true
  def testify!
    update!(test: true)
  end

  # Sets the model instance attribute of `dummy` to `true`
  #
  # @return [Boolean]
  #
  # @example Set user as dummy instance
  #   user.dummy #=> false
  #   user.dummify! #=> true
  #   user.dummy #=> true
  def dummify!
    update!(dummy: true)
  end
end
