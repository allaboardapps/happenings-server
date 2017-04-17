require "rails_helper"
require "concerns/activatable_shared"

describe User, type: :model do
  it_behaves_like "activatable"

  it { is_expected.to have_many :addresses }

  describe "validations" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:user)).to be_valid
    end

    it "is invalid without an email address" do
      expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    end

    it "is invalid without a password" do
      expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
    end

    it "is invalid without a time zone" do
      expect(FactoryGirl.build(:user, time_zone: nil)).not_to be_valid
    end
  end

  describe "#full_name" do
    it "renders the user first and last name separated by a space" do
      user = FactoryGirl.create(:user, first_name: "Bubba", last_name: "Jones")
      expect(user.full_name).to eq "#{user.first_name.capitalize} #{user.last_name.capitalize}"
    end

    it "capitalizes the user first and last names" do
      user = FactoryGirl.create(:user, first_name: "bubba", last_name: "jones")
      expect(user.full_name).to eq "#{user.first_name.capitalize} #{user.last_name.capitalize}"
    end

    it "capitalizes the user first name and trims any pre-fixed space" do
      user = FactoryGirl.create(:user, first_name: "bubba", last_name: "")
      expect(user.full_name).to eq user.first_name.capitalize
    end

    it "capitalizes the user last name and trims any post-fixed space" do
      user = FactoryGirl.create(:user, first_name: "", last_name: "jones")
      expect(user.full_name).to eq user.last_name.capitalize
    end

    context "nil names" do
      it "capitalizes the user last name and trims any post-fixed space" do
        user = FactoryGirl.create(:user, first_name: nil, last_name: "jones")
        expect(user.full_name).to eq user.last_name.capitalize
      end

      it "capitalizes the user first name and trims any post-fixed space" do
        user = FactoryGirl.create(:user, first_name: "bubba", last_name: nil)
        expect(user.full_name).to eq user.first_name.capitalize
      end

      it "returns a blank" do
        user = FactoryGirl.create(:user, first_name: nil, last_name: nil)
        expect(user.full_name).to eq ""
      end
    end

    describe "#first_name_abbreviated" do
      it "renders the user first name abbreviated with period, last name by seven characters" do
        user = FactoryGirl.create(:user, first_name: "Bubba", last_name: "Schemmel")
        expect(user.first_name_abbreviated).to eq "B. Schemme"
      end

      it "renders the user first name abbreviated with period, last name by seven or less chars" do
        user = FactoryGirl.create(:user, first_name: "Mark", last_name: "Smith")
        expect(user.first_name_abbreviated).to eq "M. Smith"
      end

      it "renders the user first abbreviated by a single character and last name by argument" do
        user = FactoryGirl.create(:user, first_name: "Bubba", last_name: "Jones-Smitherwich")
        expect(user.first_name_abbreviated(10)).to eq "B. Jones-Smit"
      end
    end

    describe "#last_name_abbreviated" do
      it "renders the user first name by seven characters, last name abbreviated with period" do
        user = FactoryGirl.create(:user, first_name: "Bubbalicious", last_name: "Schemmel")
        expect(user.last_name_abbreviated).to eq "Bubbali S."
      end

      it "renders the user first name by seven or less chars, last name abbreviated with period" do
        user = FactoryGirl.create(:user, first_name: "Mark", last_name: "Smith")
        expect(user.last_name_abbreviated).to eq "Mark S."
      end

      it "renders the user first abbreviated by a single character and last name by argument" do
        user = FactoryGirl.create(:user, first_name: "Bubbalicious", last_name: "Jones-Smitherwich")
        expect(user.last_name_abbreviated(14)).to eq "Bubbalicious J."
      end
    end

    describe "#admin?" do
      it "returns true if user has a role qualified as admin" do
        user = FactoryGirl.create :user, roles: [UserRoles::ADMIN]
        expect(user.admin?).to be_truthy
      end

      it "returns false if user has any role other than admin" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER]
        expect(user.admin?).to be_falsey
      end
    end

    describe "#customer?" do
      it "returns true if user has role of customer" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER]
        expect(user.customer?).to be_truthy
      end

      it "returns false if user has any role other than customer" do
        user = FactoryGirl.create :user, roles: [UserRoles::ADMIN]
        expect(user.customer?).to be_falsey
      end
    end

    describe "#basic?" do
      it "returns true if user has status of basic" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.basic?).to be_truthy
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::PREMIUM]
        expect(user.basic?).to be_truthy
      end
    end

    describe "#role?" do
      it "returns true if user has matching user role" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.role?(UserRoles::CUSTOMER)).to be_truthy
      end

      it "returns false if user does not have matching user role" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.role?(UserRoles::ADMIN)).to be_falsey
      end
    end

    describe "#status?" do
      it "returns true if user has matching user status" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.status?(UserStatuses::BASIC)).to be_truthy
      end

      it "returns false if user does not have matching user status" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.status?(UserStatuses::PRO)).to be_falsey
      end
    end

    describe "#pro?" do
      it "returns false if user has status of basic" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.pro?).to be_falsey
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::PREMIUM]
        expect(user.pro?).to be_truthy
      end

      it "returns true if user has status of pro" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::PRO]
        expect(user.pro?).to be_truthy
      end
    end

    describe "#premium?" do
      it "returns false if user has status of basic" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::BASIC]
        expect(user.premium?).to be_falsey
      end

      it "returns false if user has status of pro" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::PRO]
        expect(user.premium?).to be_falsey
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER], statuses: [UserStatuses::PREMIUM]
        expect(user.premium?).to be_truthy
      end
    end

    describe "#active_admin_access?" do
      it "returns true if user has a role qualified for Active Admin access" do
        user = FactoryGirl.create :user, roles: [UserRoles::ADMIN]
        expect(user.active_admin_access?).to be_truthy
      end

      it "returns true if user has any role qualified for Active Admin access" do
        user = FactoryGirl.create :user, roles: [UserRoles::ADMIN]
        expect(user.active_admin_access?).to be_truthy
      end

      it "returns false if user has no role qualified for Active Admin access" do
        user_1 = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER]
        user_2 = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER]
        expect(user_1.active_admin_access?).to be_falsey
        expect(user_2.active_admin_access?).to be_falsey
      end
    end
  end

  describe "#roles_presented" do
    it "sets the archived flag to false" do
      user = FactoryGirl.create :user, roles: [UserRoles::CUSTOMER, UserRoles::ADMIN]
      expect(user.roles_presented).to eq "#{UserRoles::CUSTOMER}, #{UserRoles::ADMIN}"
    end
  end

  describe ".seed" do
    it "given no arguments, it creates a user with a role of customer and setting of dummy" do
      10.times.each do
        User.seed
      end

      expect(User.actives.count).to eq 0
      expect(User.inactives.count).to eq 10
      expect(User.customers.count).to eq 10
      expect(User.dummies.count).to eq 10
    end

    it "given staff and non-dummy arguments, it creates a user with a role of staff and settings of active" do
      6.times.each do
        User.seed(roles: UserRoles::STAFF, dummy: false)
      end

      expect(User.actives.count).to eq 6
      expect(User.customers.count).to eq 0
      expect(User.staffers.count).to eq 6
      expect(User.inactives.count).to eq 0
      expect(User.dummies.count).to eq 0
    end
  end

  describe ".seed_admin" do
    it "creates a user with a role of `admin`" do
      admins = [
        { email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name },
        { email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
      ]
      admins.each do |admin|
        User.seed_admin(admin)
      end

      admin = User.first
      expect(admin.roles).to eq [UserRoles::ADMIN]
      expect(User.admins.count).to eq 2
    end

    it "does not duplicate an admin user based on email address" do
      dupe_email = Faker::Internet.email

      admins = [
        { email: dupe_email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name },
        { email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name },
        { email: Faker::Internet.email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name },
        { email: dupe_email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }
      ]
      admins.each do |admin|
        User.seed_admin(admin)
      end

      admin = User.last
      expect(admin.roles).to eq [UserRoles::ADMIN]
      expect(User.admins.count).to eq 3
    end
  end
end
