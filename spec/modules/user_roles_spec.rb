require "rails_helper"

describe UserRoles, type: :module do
  it "renders a role" do
    expect(described_class::ADMIN).to eq "admin"
    expect(described_class::CUSTOMER).to eq "customer"
  end

  it "returns a list of system roles" do
    expect(described_class.system_roles).to include("staff", "admin")
  end

  context ".all" do
    it "returns a list of all roles" do
      expect(described_class.all).to include("admin", "staff", "customer")
    end
  end
end
