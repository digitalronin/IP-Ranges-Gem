require 'spec_helper'

describe IpRanges do
  include IpRanges

  context "checking for overlaps" do

    it "explains range a equals range b" do
      list = %w(1.2.3.0..1.2.3.255 1.2.3.0/24)
      overlaps = check_for_overlaps(list)
      expect(overlaps[0]).to eq("1.2.3.0..1.2.3.255 equals range 1.2.3.0/24")
    end

    it "explains range a is contained by range b" do
      list = %w(1.2.3.4..1.2.3.5 1.2.3.4..1.2.3.8)
      overlaps = check_for_overlaps(list)
      expect(overlaps[0]).to eq("1.2.3.4..1.2.3.5 is contained by range 1.2.3.4..1.2.3.8")
    end

    it "explains range a contains range b" do
      list = %w(1.2.3.4..1.2.3.8 1.2.3.4..1.2.3.5)
      overlaps = check_for_overlaps(list)
      expect(overlaps[0]).to eq("1.2.3.4..1.2.3.8 contains range 1.2.3.4..1.2.3.5")
    end

    it "explains overlap" do
      list = %w(1.2.3.4..1.2.3.8 1.2.3.5..1.2.3.9)
      overlaps = check_for_overlaps(list)
      expect(overlaps[0]).to eq("1.2.3.4..1.2.3.8 overlaps with 1.2.3.5..1.2.3.9")
    end

    it "counts the overlaps" do
      list = %w(1.2.3.4..1.2.3.8 1.2.3.4..1.2.3.5 1.2.3.8)
      expect(check_for_overlaps(list).size).to eq(2)
    end

    it "takes a list" do
      check_for_overlaps []
    end

  end

end
