require 'spec/spec_helper'

describe IpRanges::Ip do
  before do
    @ip = IpRanges::Ip.new
  end

  it "duplicates with a different object" do
    @ip.number = "1.200.3.4"
    ip2 = @ip.dup
    ip2.object_id.should_not == @ip.object_id
  end

  it "duplicates" do
    @ip.number = "1.200.3.4"
    ip2 = @ip.dup
    ip2.should == @ip
  end

  it "is greater than or equal to" do
    @ip.number = "1.200.3.4"
    eq = IpRanges::Ip.new :number => "1.200.3.4"
    lt = IpRanges::Ip.new :number => "1.200.3.3"
    [eq, lt].each {|test| (@ip >= test).should be_true}
  end

  it "is equivalent" do
    @ip.number = "1.200.3.4"
    ip2 = IpRanges::Ip.new :number => "1.200.3.4"
    @ip.should == ip2
  end

  it "renders to string" do
    @ip.number = "1.200.3.4"
    @ip.to_s.should == "1.200.3.4"
  end

  it "knows 1.2.3.255 < 1.2.4.0" do
    @ip.number = '1.2.3.255'
    ip2 = IpRanges::Ip.new :number => "1.2.4.0"
    (@ip > ip2).should be_false
  end

  it "knows 1.2.4.0 >= 1.2.3.255" do
    @ip.number = "1.2.4.0"
    ip2 = IpRanges::Ip.new :number => '1.2.3.255'
    (@ip >= ip2).should be_true
  end

  it "knows 1.200.3.4 > 1.199.3.4" do
    @ip.number = "1.200.3.4"
    ip2 = IpRanges::Ip.new :number => '1.199.3.4'
    (@ip > ip2).should be_true
  end

  it "knows 1.2.3.4 > 1.2.2.4" do
    @ip.number = "1.2.3.4"
    ip2 = IpRanges::Ip.new :number => '1.2.2.4'
    (@ip > ip2).should be_true
  end

  it "knows 1.2.3.4 > 1.2.3.3" do
    @ip.number = "1.2.3.4"
    ip2 = IpRanges::Ip.new :number => '1.2.3.3'
    (@ip > ip2).should be_true
  end

  it "knows 1.2.3.3 <= 1.2.3.4" do
    @ip.number = "1.2.3.3"
    ip2 = IpRanges::Ip.new :number => '1.2.3.4'
    (@ip > ip2).should be_false
  end

  it "increments when 2nd tuple hits 255" do
    @ip.number = "1.255.255.255"
    @ip.increment.should == "2.0.0.0"
  end

  it "increments when 3rd tuple hits 255" do
    @ip.number = "1.2.255.255"
    @ip.increment.should == "1.3.0.0"
  end

  it "increments when last tuple hits 255" do
    @ip.number = "1.2.3.255"
    @ip.increment.should == "1.2.4.0"
  end

  it "increments last tuple" do
    @ip.number = '1.2.3.4'
    @ip.increment.should == "1.2.3.5"
  end

end
