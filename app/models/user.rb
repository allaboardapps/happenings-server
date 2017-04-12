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

  scope :autocomplete, -> (user_query) { active.where("first_name ilike ? or last_name ilike ?", "#{user_query}%", "#{user_query}%").order(last_name: :asc, first_name: :asc) }
  scope :admins, -> { where("'#{UserRoles::ADMIN}' = ANY (roles)") }
  scope :staffers, -> { where("'#{UserRoles::STAFF}' = ANY (roles)") }
  scope :customers, -> { where("'#{UserRoles::CUSTOMER}' = ANY (roles)") }
  scope :with_one_of_roles, ->(*roles) { where.overlap(roles: roles) }

  # belongs_to :location
  # has_many :activities, as: :loggable
  # has_many :authored_events, class_name: "Event", foreign_key: :author_id
  # has_many :calendar_users
  # has_many :calendars, through: :calendar_users
  # has_many :event_users
  # has_many :events, through: :event_users
  # has_many :favorites
  # has_many :favorited_events, through: :favorites, source: :event
  # has_many :group_users
  # has_many :groups, through: :group_users
  # has_many :organization_users
  # has_many :organizations, through: :organization_users
  # has_one :region, through: :location

  after_create :set_default_role

  def generate_token!
    self.token = SecureRandom.hex
    save!
  end

  def full_name
    "#{first_name} #{last_name}".gsub(/\b('?[a-z])/) { $1.capitalize }.strip
  end

  def first_name_abbreviated(last_name_length = 7)
    first_name_abbrev = first_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, 1)
    last_name_abbrev = last_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, last_name_length)
    "#{first_name_abbrev}. #{last_name_abbrev}"
  end

  def last_name_abbreviated(first_name_length = 7)
    first_name_abbrev = first_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, first_name_length)
    last_name_abbrev = last_name.gsub(/\b('?[a-z])/) { $1.capitalize }.strip.slice(0, 1)
    "#{first_name_abbrev} #{last_name_abbrev}."
  end

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

  def set_default_role
    update_attribute :roles, [UserRoles::CUSTOMER] if roles.empty?
  end

  def admin?
    role? UserRoles::ADMIN
  end

  def customer?
    role? UserRoles::CUSTOMER
  end

  def status?(status)
    statuses.include? status
  end

  def basic?
    status?(UserStatuses::BASIC) || status?(UserStatuses::PRO) || status?(UserStatuses::PREMIUM)
  end

  def pro?
    status?(UserStatuses::PRO) || status?(UserStatuses::PREMIUM)
  end

  def premium?
    status?(UserStatuses::PREMIUM)
  end

  def roles_presented
    roles.join(", ")
  end
end
