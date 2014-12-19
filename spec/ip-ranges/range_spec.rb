require 'spec/spec_helper'

describe IpRanges::Range do
  let(:range_str) { '1.2.3.4' }
  subject(:range) { described_class.new(:range => range_str, :throttle => false) }

  describe "#count" do
    context "with one ip" do
      let(:range_str) { '1.2.3.4' }

      it "counts" do
        expect(range.count).to eq(1)
      end
    end

    context "with dotted range" do
      let(:range_str) { '1.2.3.4 .. 1.2.3.6' }

      it "counts" do
        expect(range.count).to eq(3)
      end
    end


    context "with cidr range" do
      let(:range_str) { '1.2.3.0/24' }

      it "counts" do
        expect(range.count).to eq(256)
      end
    end
  end

  describe "#to_s" do

    it "prints empty string" do
      range = described_class.new(:range => '')
      expect(range.to_s).to eq('')
    end

    it "prints one ip" do
      range = described_class.new(:range => '1.2.3.4')
      expect(range.to_s).to eq('1.2.3.4')
    end

    it "prints dotted range" do
      range = described_class.new(:range => '1.2.3.4 .. 1.2.3.6')
      expect(range.to_s).to eq('1.2.3.4..1.2.3.6')
    end

  end

  context "pushing" do
    let(:ip1) { IpRanges::Ip.new(:number => '1.1.1.1') }
    let(:ip2) { IpRanges::Ip.new(:number => '1.1.1.2') }
    let(:ip3) { IpRanges::Ip.new(:number => '1.1.1.3') }
    let(:ip4) { IpRanges::Ip.new(:number => '1.1.1.4') }

    context "empty range" do
      let(:empty) { described_class.new(:range => '') }

      it "pushes" do
        res = empty.push(ip1)
        expect(res).to be_truthy
      end

      it "sets first ip" do
        empty.push(ip1)
        expect(empty.first).to eq(ip1)
      end

      it "sets last ip" do
        empty.push(ip1)
        expect(empty.last).to eq(ip1)
      end
    end

    context "range with start" do
      let(:r1) { described_class.new(:range => ip1.to_s) }

      context "pushing next ip" do
        it "pushes" do
          res = r1.push(ip2)
          expect(res).to be_truthy
        end

        it "sets last ip" do
          r1.push(ip2)
          expect(r1.last).to eq(ip2)
        end
      end

      context "pushing non-contiguous ip" do
        it "doesn't push" do
          res = r1.push(ip3)
          expect(res).to be_falsey
        end

        it "doesn't set last ip" do
          r1.push(ip3)
          expect(r1.last).to eq(r1.first)
        end
      end
    end

    context "range with start and end" do
      let(:range) { described_class.new(:range => [ip1.to_s, ip2.to_s].join('..')) }

      context "pushing next ip" do
        it "pushes" do
          res = range.push(ip3)
          expect(res).to be_truthy
        end

        it "sets last ip" do
          range.push(ip3)
          expect(range.last).to eq(ip3)
        end
      end

      context "pushing non-contiguous ip" do
        it "doesn't push" do
          res = range.push(ip4)
          expect(res).to be_falsey
        end

        it "doesn't set last ip" do
          range.push(ip4)
          expect(range.last).to eq(ip2)
        end
      end
    end
  end

  context "checking for overlaps" do

    it "knows when range a contains range b" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.3..1.2.3.5'
      ipr2 = IpRanges::Range.new :range => '1.2.3.4..1.2.3.5'
      expect(ipr1.contains_range?(ipr2)).to be_truthy
    end

    it "knows when range a does not contain range b" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4..1.2.3.5'
      ipr2 = IpRanges::Range.new :range => '1.2.3.5..1.2.3.6'
      expect(ipr1.contains_range?(ipr2)).to be_falsey
    end

    it "knows there is an overlap" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4'
      ipr2 = IpRanges::Range.new :range => '1.2.3.4'
      expect(ipr1.overlaps_range?(ipr2)).to be_truthy
    end

    it "knows there is no overlap" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4'
      ipr2 = IpRanges::Range.new :range => '1.2.3.5'
      expect(ipr1.overlaps_range?(ipr2)).to be_falsey
    end

    it "accepts Ip object for contains_ip" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      ip = IpRanges::Ip.new :number => '1.2.3.5'
      expect(ipr.contains_ip?(ip)).to be_truthy
    end

    it "knows it doesn't contain ip numbers" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      %w(1.2.3.3 1.2.3.7).each {|num| expect(ipr.contains_ip?(num)).to be_falsey}
    end

    it "knows it contains an ip number" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      %w(1.2.3.4 1.2.3.5 1.2.3.6).each {|num| expect(ipr.contains_ip?(num)).to be_truthy}
    end

  end

  it "knows it equals another range" do
    dotted = IpRanges::Range.new :range => '1.2.3.0..1.2.3.255'
    cidr   = IpRanges::Range.new :range => '1.2.3.0/24'
    expect(dotted == cidr).to be_truthy
    expect(cidr == dotted).to be_truthy
  end

  it "iterates over all ips" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.6'
    expected = [
      IpRanges::Ip.new(:number => '1.2.3.4'),
      IpRanges::Ip.new(:number => '1.2.3.5'),
      IpRanges::Ip.new(:number => '1.2.3.6')
    ]
    arr = []
    ipr.each_ip {|ip| arr << ip}
    expect(arr).to eq(expected)
  end

  it "returns last ip from cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    expect(ipr.last.to_s).to eq('1.2.3.255')
  end

  it "returns first ip from cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    expect(ipr.first.to_s).to eq('1.2.3.0')
  end

  it "instantiates from a cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    expect(ipr).to be_kind_of(IpRanges::Range)
  end

  it "returns last ip from dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    expect(ipr.last.to_s).to eq('1.2.3.5')
  end

  it "returns first ip from dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    expect(ipr.first.to_s).to eq('1.2.3.4')
  end

  it "instantiates from a dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    expect(ipr).to be_kind_of(IpRanges::Range)
  end

  it "returns last ip" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    expect(ipr.last.to_s).to eq('1.2.3.4')
  end

  it "returns first ip" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    expect(ipr.first.to_s).to eq('1.2.3.4')
  end

  it "instantiates from a single IP" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    expect(ipr).to be_kind_of(IpRanges::Range)
  end

  it "instantiates" do
    ipr = IpRanges::Range.new :range => ''
    expect(ipr).to be_kind_of(IpRanges::Range)
  end
end
