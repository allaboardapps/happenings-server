class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include Activatable

  validates :email, presence: true
  validates :time_zone, presence: true

  devise :database_authenticatable, :recoverable, :rememberable, :registerable,
         :trackable, :validatable, :confirmable, :lockable, :timeoutable

  scope :autocomplete, (->(user_query) { active.where("first_name ilike ? or last_name ilike ?", "#{user_query}%", "#{user_query}%").order(last_name: :asc, first_name: :asc) })
  scope :admins, (-> { where("'#{UserRoles::ADMIN}' = ANY (roles)") })
  scope :staffers, (-> { where("'#{UserRoles::STAFF}' = ANY (roles)") })
  scope :customers, (-> { where("'#{UserRoles::CUSTOMER}' = ANY (roles)") })
  scope :with_one_of_roles, (->(*roles) { where.overlap(roles: roles) })

  after_create :set_default_role

  # Generates a new token on a user instance `token` attribute
  #
  # @return [Boolean]
  #
  # @example Render a user's full name
  #   user.token #=> nil
  #   user.generate_token! #=> true
  #   user.token #=> "7885e2132819484ab59e09464d9ac025"
  def generate_token!
    self.token = SecureRandom.hex
    save!
  end

  # Concatenates, capitalizes, and removes whitespace from
  #   the `first_name` and `last_name` of a user instance
  #
  # @return [String]
  #
  # @example Render a user's full name
  #   user.first_name #=> "Randy"
  #   user.last_name #=> "Burgess"
  #   user.full_name #=> "Randy Burgess"
  def full_name
    "#{first_name} #{last_name}".gsub(/\b('?[a-z])/) { $1.capitalize }.strip
  end

  # Returns an abbreviated `first_name` and length-specified `last_name` of a user instance
  #
  # @return [String]
  #
  # @example Render a user's first name abbreviated and last name 6 max characters
  #   user.first_name #=> "Randy"
  #   user.last_name #=> "Burgess"
  #   user.first_name_abbreviated(6) #=> "R. Burges"
  def first_name_abbreviated(last_name_length = 7)
    first_name_abbrev = first_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, 1)
    last_name_abbrev = last_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, last_name_length)
    "#{first_name_abbrev}. #{last_name_abbrev}"
  end

  # Returns a length-specified `first_name` and an abbreviated `last_name` of a user instance
  #
  # @return [String]
  #
  # @example Render a user's last name abbreviated and first name 4 max characters
  #   user.first_name #=> "Randy"
  #   user.last_name #=> "Burgess"
  #   user.first_name_abbreviated(4) #=> "Rand B."
  def last_name_abbreviated(first_name_length = 7)
    first_name_abbrev = first_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, first_name_length)
    last_name_abbrev = last_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, 1)
    "#{first_name_abbrev} #{last_name_abbrev}."
  end

  # Specifies whether a user instance is authorized for active admin access
  #
  # @return [Boolean]
  #
  # @example Is the user allowed active admin access?
  #   user.roles #=> ['admin']
  #   user.active_admin_access? #=> true
  #
  #   user.roles #=> ['customer']
  #   user.active_admin_access? #=> false
  def active_admin_access?
    roles.any? { |role| UserRoles.active_admin_roles.include?(role) }
  end

  def active_for_authentication?
    super && !archived?
  end

  def user_role?
    roles.any? { |role| Roles.user_roles.include?(role) }
  end

  def role?(role)
    roles.include? role
  end

  def roles_contain_one_of?(allowed_roles)
    roles.any? do |role|
      allowed_roles.include? role
    end
  end

  def admin?
    role?(UserRoles::ADMIN)
  end

  def customer?
    role?(UserRoles::CUSTOMER)
  end

  def status?(status)
    statuses.include?(status)
  end

  # Specifies if user has status equal to or above `basic`
  #
  # @return [Boolean]
  #
  # @example Return true if user has status of `premium`
  #   user.statuses #=> ["premium"]
  #   user.basic? #=> true
  def basic?
    status?(UserStatuses::BASIC) || status?(UserStatuses::PRO) || status?(UserStatuses::PREMIUM)
  end

  # Specifies if user has status equal to or above `pro`
  #
  # @return [Boolean]
  #
  # @example Return true if user has status of `premium`
  #   user.statuses #=> ["premium"]
  #   user.premium? #=> true
  #
  # @example Return false if user has status of `basic`
  #   user.statuses #=> ["basic"]
  #   user.pro? #=> false
  def pro?
    status?(UserStatuses::PRO) || status?(UserStatuses::PREMIUM)
  end

  # Specifies if user has status equal to `premium`
  #
  # @return [Boolean]
  #
  # @example Return true if user has status of `premium`
  #   user.statuses #=> ["premium"]
  #   user.premium? #=> true
  #
  # @example Return false if user has status of `pro`
  #   user.statuses #=> ["pro"]
  #   user.premium? #=> false
  def premium?
    status?(UserStatuses::PREMIUM)
  end

  # Renders a comma-separated list of user instance roles
  #
  # @return [String]
  #
  # @example Print the user roles separated by comma
  #   user.roles #=> ['user', admin']
  #   user.roles_presented #=> "user, admin"
  def roles_presented
    roles.join(", ")
  end

  # Creates a user instance for test/dev needs and skips confirmation email
  #
  # @param roles [String] default is "customer"
  # @param dummy [Boolean] default is `true`
  # @return [Object] the newly created user with role of `customer` and dummy set to `true`
  #
  # @example Create a seed instance of a user with dummy trait, roles of customer
  #   user.seed #=> user
  #   user.dummy #=> true
  #   user.roles #=> ["customer"]
  def self.seed(roles: UserRoles::CUSTOMER, dummy: true)
    fake_password = "A1{Faker::Internet.password(10, 120)}"
    user_attrs = {
      email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
      password: fake_password, password_confirmation: fake_password, roles: [roles], time_zone: "UTC",
      archived: false, test: false, dummy: dummy
    }

    user = new(user_attrs)
    user.skip_confirmation!
    user.save!
    user
  end

  # Creates an admin instance for test/dev needs and skips confirmation email
  #
  # @param user [Hash] user hash with properties of `email`, `first_name`, `Last_name`
  # @return [Object] the newly created user with role of `admin`
  #
  # @example Create a seed instance of a user with dummy trait, roles of customer
  #   user.seed_admin #=> user
  #   user.roles #=> ["admin"]
  def self.seed_admin(user)
    temp_password = "A1{Faker::Internet.password(10, 120)}"
    admin = find_by(email: user[:email])

    return if admin.present?
    admin = create(
      email: user[:email], first_name: user[:first_name], last_name: user[:last_name],
      password: temp_password, password_confirmation: temp_password, roles: [UserRoles::ADMIN], time_zone: "UTC"
    )
    admin.skip_confirmation!
    admin.save!
    admin
  end

  private

  # Sets the user role to `customer` if no role exists
  #
  # @return [nil]
  #
  # @example Set the user default role to `customer` if none exists
  #   user.set_default_role #=> nil
  def set_default_role
    update_attribute :roles, [UserRoles::CUSTOMER] if roles.empty?
  end
end
