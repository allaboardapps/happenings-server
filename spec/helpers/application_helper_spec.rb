require "rails_helper"

describe ApplicationHelper, type: :helper do
  describe "#humanize_uuid" do
    it "formats a uuid string to a default number of characters with elipsis" do
      user = FactoryGirl.create :user
      expect(humanize_uuid(user.id).length).to eq 13
      expect(humanize_uuid(user.id)).to eq "#{user.id[0..9]}..."
    end

    it "formats a uuid string to a specified number of characters with elipsis" do
      user = FactoryGirl.create :user
      expect(humanize_uuid(user.id, 5).length).to eq 8
      expect(humanize_uuid(user.id, 5)).to eq "#{user.id[0..4]}..."
    end

    it "formats a uuid string to a specified number of characters without elipsis" do
      user = FactoryGirl.create :user
      expect(humanize_uuid(user.id, 6, false).length).to eq 6
      expect(humanize_uuid(user.id, 6, false)).to eq user.id[0..5].to_s
    end
  end
end
