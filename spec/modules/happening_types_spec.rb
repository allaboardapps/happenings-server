require "rails_helper"

describe HappeningTypes, type: :module do
  it "renders a happening type" do
    expect(described_class::THEATER).to eq "theater"
  end

  it "returns a list of all happening types" do
    expect(described_class.all).to include "theater", "sports"
  end
end
