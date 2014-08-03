require 'spec/spec_helper'

describe IpRanges::Range do
  before do
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
        res.should be_true
      end

      it "sets first ip" do
        empty.push(ip1)
        empty.first.should eq(ip1)
      end
    end

    context "range with start" do
      let(:r1) { described_class.new(:range => ip1.to_s) }

      context "pushing next ip" do
        it "pushes" do
          res = r1.push(ip2)
          res.should be_true
        end

        it "sets last ip" do
          r1.push(ip2)
          r1.last.should eq(ip2)
        end
      end

      context "pushing non-contiguous ip" do
        it "doesn't push" do
          res = r1.push(ip3)
          res.should be_false
        end

        it "doesn't set last ip" do
          r1.push(ip3)
          r1.last.should eq(r1.first)
        end
      end
    end

    context "range with start and end" do
      let(:range) { described_class.new(:range => [ip1.to_s, ip2.to_s].join('..')) }

      context "pushing next ip" do
        it "pushes" do
          res = range.push(ip3)
          res.should be_true
        end

        it "sets last ip" do
          range.push(ip3)
          range.last.should eq(ip3)
        end
      end

      context "pushing non-contiguous ip" do
        it "doesn't push" do
          res = range.push(ip4)
          res.should be_false
        end

        it "doesn't set last ip" do
          range.push(ip4)
          range.last.should eq(ip2)
        end
      end
    end
  end

  context "checking for overlaps" do

    it "knows when range a contains range b" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.3..1.2.3.5'
      ipr2 = IpRanges::Range.new :range => '1.2.3.4..1.2.3.5'
      ipr1.contains_range?(ipr2).should be_true
    end

    it "knows when range a does not contain range b" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4..1.2.3.5'
      ipr2 = IpRanges::Range.new :range => '1.2.3.5..1.2.3.6'
      ipr1.contains_range?(ipr2).should be_false
    end

    it "knows there is an overlap" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4'
      ipr2 = IpRanges::Range.new :range => '1.2.3.4'
      ipr1.overlaps_range?(ipr2).should be_true
    end

    it "knows there is no overlap" do
      ipr1 = IpRanges::Range.new :range => '1.2.3.4'
      ipr2 = IpRanges::Range.new :range => '1.2.3.5'
      ipr1.overlaps_range?(ipr2).should be_false
    end

    it "accepts Ip object for contains_ip" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      ip = IpRanges::Ip.new :number => '1.2.3.5'
      ipr.contains_ip?(ip).should be_true
    end

    it "knows it doesn't contain ip numbers" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      %w(1.2.3.3 1.2.3.7).each {|num| ipr.contains_ip?(num).should be_false}
    end

    it "knows it contains an ip number" do
      ipr = IpRanges::Range.new :range => '1.2.3.4..1.2.3.6'
      %w(1.2.3.4 1.2.3.5 1.2.3.6).each {|num| ipr.contains_ip?(num).should be_true}
    end

  end

  it "knows it equals another range" do
    dotted = IpRanges::Range.new :range => '1.2.3.0..1.2.3.255'
    cidr   = IpRanges::Range.new :range => '1.2.3.0/24'
    (dotted == cidr).should be_true
    (cidr == dotted).should be_true
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
    arr.should == expected
  end

  it "returns last ip from cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    ipr.last.to_s.should == '1.2.3.255'
  end

  it "returns first ip from cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    ipr.first.to_s.should == '1.2.3.0'
  end

  it "instantiates from a cidr range" do
    ipr = IpRanges::Range.new :range => '1.2.3.0/24'
    ipr.should be_kind_of(IpRanges::Range)
  end

  it "returns last ip from dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    ipr.last.to_s.should == '1.2.3.5'
  end

  it "returns first ip from dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    ipr.first.to_s.should == '1.2.3.4'
  end

  it "instantiates from a dotted range" do
    ipr = IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5'
    ipr.should be_kind_of(IpRanges::Range)
  end

  it "returns last ip" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    ipr.last.to_s.should == '1.2.3.4'
  end

  it "returns first ip" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    ipr.first.to_s.should == '1.2.3.4'
  end

  it "instantiates from a single IP" do
    ipr = IpRanges::Range.new :range => '1.2.3.4'
    ipr.should be_kind_of(IpRanges::Range)
  end

  it "instantiates" do
    ipr = IpRanges::Range.new :range => ''
    ipr.should be_kind_of(IpRanges::Range)
  end
end
