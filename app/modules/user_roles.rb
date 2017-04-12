module UserRoles
  ADMIN = "admin".freeze
  STAFF = "staff".freeze
  CUSTOMER = "customer".freeze

  def self.system_roles
    [self::ADMIN, self::STAFF]
  end

  def self.customer_roles
    [self::CUSTOMER]
  end

  def self.active_admin_roles
    [self::ADMIN]
  end

  def self.all
    [self::ADMIN, self::STAFF, self::CUSTOMER]
  end
end
