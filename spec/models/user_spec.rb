require "rails_helper"
require "concerns/activatable_shared"

describe User, type: :model do
  it_behaves_like "activatable"

  # it { is_expected.to belong_to :location }
  # it { is_expected.to have_many :activities }
  # it { is_expected.to have_many :authored_events }
  # it { is_expected.to have_many :calendar_users }
  # it { is_expected.to have_many :calendars }
  # it { is_expected.to have_many :event_users }
  # it { is_expected.to have_many :events }
  # it { is_expected.to have_many :favorited_events }
  # it { is_expected.to have_many :favorites }
  # it { is_expected.to have_many :organization_users }
  # it { is_expected.to have_many :organizations }
  # it { is_expected.to have_one :region }

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

    xit "is invalid without a sufficient password" do
      expect(FactoryGirl.build(:user, password: "1234567")).not_to be_valid
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
        user = FactoryGirl.create :user, :admin
        expect(user.admin?).to be_truthy
      end

      it "returns false if user has any role other than admin" do
        user = FactoryGirl.create :user, :customer
        expect(user.admin?).to be_falsey
      end
    end

    describe "#customer?" do
      it "returns true if user has role of customer" do
        user = FactoryGirl.create :user, :customer
        expect(user.customer?).to be_truthy
      end

      it "returns false if user has any role other than customer" do
        user = FactoryGirl.create :user, :admin
        expect(user.customer?).to be_falsey
      end
    end

    describe "#basic?" do
      it "returns true if user has status of basic" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.basic?).to be_truthy
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, :customer, :premium
        expect(user.basic?).to be_truthy
      end
    end

    describe "#role?" do
      it "returns true if user has matching user role" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.role?(UserRoles::CUSTOMER)).to be_truthy
      end

      it "returns false if user does not have matching user role" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.role?(UserRoles::ADMIN)).to be_falsey
      end
    end

    describe "#status?" do
      it "returns true if user has matching user status" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.status?(UserStatuses::BASIC)).to be_truthy
      end

      it "returns false if user does not have matching user status" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.status?(UserStatuses::PRO)).to be_falsey
      end
    end

    describe "#pro?" do
      it "returns false if user has status of basic" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.pro?).to be_falsey
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, :customer, :premium
        expect(user.pro?).to be_truthy
      end

      it "returns true if user has status of pro" do
        user = FactoryGirl.create :user, :customer, :pro
        expect(user.pro?).to be_truthy
      end
    end

    describe "#premium?" do
      it "returns false if user has status of basic" do
        user = FactoryGirl.create :user, :customer, :basic
        expect(user.premium?).to be_falsey
      end

      it "returns false if user has status of pro" do
        user = FactoryGirl.create :user, :customer, :pro
        expect(user.premium?).to be_falsey
      end

      it "returns true if user has status of premium" do
        user = FactoryGirl.create :user, :customer, :premium
        expect(user.premium?).to be_truthy
      end
    end

    describe "#active_admin_access?" do
      it "returns true if user has a role qualified for Active Admin access" do
        user = FactoryGirl.create :user, :admin
        expect(user.active_admin_access?).to be_truthy
      end

      it "returns true if user has any role qualified for Active Admin access" do
        user = FactoryGirl.create :user, :admin
        expect(user.active_admin_access?).to be_truthy
      end

      it "returns false if user has no role qualified for Active Admin access" do
        user_1 = FactoryGirl.create :user, :customer
        user_2 = FactoryGirl.create :user, :customer
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
end
