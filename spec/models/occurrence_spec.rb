require "rails_helper"
require "concerns/activatable_shared"

describe Occurrence, type: :model do
  it_behaves_like "activatable"

  it { is_expected.to belong_to :happening }

  describe "validations" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:occurrence)).to be_valid
    end
  end
end
