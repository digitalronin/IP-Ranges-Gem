require 'spec/spec_helper'

describe IpRanges::Ip do
  let(:number) { "1.200.3.4" }
  subject(:ip) { described_class.new(:number => number) }

  context "duplicating" do
    let(:dup) { ip.dup }

    it "duplicates as a different object" do
      expect(dup.object_id).to_not eq(ip.object_id)
    end

    it "considers duplicate to be equivalent" do
      expect(dup).to eq(ip)
    end
  end

  it "renders to string" do
    expect(ip.to_s).to eq(number)
  end

  context "comparing" do
    let(:eql) { IpRanges::Ip.new :number => number      }
    let(:lt)  { IpRanges::Ip.new :number => "1.200.3.3" }

    it "is greater than or equal to" do
      [eql, lt].each {|test| expect(ip >= test).to be_truthy}
    end

    it "is equivalent" do
      expect(ip).to eq(eql)
    end

    context "when last tuple rolls over" do
      let(:number) { "1.2.3.255" }
      let(:bigger) { described_class.new(:number => '1.2.4.0') }

      specify { expect((ip > bigger)).to be_falsey }
      specify { expect((bigger >= ip)).to be_truthy }
    end

    context "when 2nd tuple is bigger" do
      let(:number) { '1.199.3.4'                                 }
      let(:bigger) { described_class.new(:number => '1.200.3.4') }

      specify { expect((ip > bigger)).to be_falsey }
      specify { expect((bigger >= ip)).to be_truthy }
    end

    context "when 3rd tuple is bigger" do
      let(:number) { '1.2.2.4'                                 }
      let(:bigger) { described_class.new(:number => '1.2.3.4') }

      specify { expect((ip > bigger)).to be_falsey }
      specify { expect((bigger >= ip)).to be_truthy }
    end

    context "when last tuple is bigger" do
      let(:number) { '1.2.3.3'                                 }
      let(:bigger) { described_class.new(:number => '1.2.3.4') }

      specify { expect((ip > bigger)).to be_falsey }
      specify { expect((bigger >= ip)).to be_truthy }
    end
  end

  context "incrementing" do
    context "when there are no more numbers" do
      let(:number) { '255.255.255.255' }

      it "barfs" do
        expect { ip.increment }.to raise_error(RuntimeError)
      end
    end

    context "when 2nd tuple hits 255" do
      let(:number) { '1.255.255.255' }

      specify { expect(ip.increment).to eq("2.0.0.0") }
    end

    context "when 3rd tuple hits 255" do
      let(:number) { '1.2.255.255' }

      specify { expect(ip.increment).to eq("1.3.0.0") }
    end

    context "when last tuple hits 255" do
      let(:number) { '1.2.3.255' }

      specify { expect(ip.increment).to eq("1.2.4.0") }
    end

    specify { expect(ip.increment).to eq("1.200.3.5") }
  end

end
