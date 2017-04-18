require "rails_helper"
require "concerns/activatable_shared"

describe Address, type: :model do
  it_behaves_like "activatable"

  it { is_expected.to belong_to :author }

  describe "validations" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:address)).to be_valid
    end
  end
end
