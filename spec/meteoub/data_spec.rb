require "spec_helper"

describe MeteoUB::Data do
  describe "#new" do
    it "fetches and parses data" do
      data = described_class.new
      expect(data).not_to be_nil
    end
  end
end


