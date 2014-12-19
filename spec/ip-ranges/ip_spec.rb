require 'spec/spec_helper'

describe IpRanges::Ip do
  before do
    @ip = IpRanges::Ip.new
  end

  it "duplicates with a different object" do
    @ip.number = "1.200.3.4"
    ip2 = @ip.dup
    expect(ip2.object_id).to_not eq(@ip.object_id)
  end

  it "duplicates" do
    @ip.number = "1.200.3.4"
    ip2 = @ip.dup
    expect(ip2).to eq(@ip)
  end

  it "is greater than or equal to" do
    @ip.number = "1.200.3.4"
    eq = IpRanges::Ip.new :number => "1.200.3.4"
    lt = IpRanges::Ip.new :number => "1.200.3.3"
    [eq, lt].each {|test| expect(@ip >= test).to be_truthy}
  end

  it "is equivalent" do
    @ip.number = "1.200.3.4"
    ip2 = IpRanges::Ip.new :number => "1.200.3.4"
    expect(@ip).to eq(ip2)
  end

  it "renders to string" do
    @ip.number = "1.200.3.4"
    expect(@ip.to_s).to eq("1.200.3.4")
  end

  it "knows 1.2.3.255 < 1.2.4.0" do
    @ip.number = '1.2.3.255'
    ip2 = IpRanges::Ip.new :number => "1.2.4.0"
    expect((@ip > ip2)).to be_falsey
  end

  it "knows 1.2.4.0 >= 1.2.3.255" do
    @ip.number = "1.2.4.0"
    ip2 = IpRanges::Ip.new :number => '1.2.3.255'
    expect((@ip >= ip2)).to be_truthy
  end

  it "knows 1.200.3.4 > 1.199.3.4" do
    @ip.number = "1.200.3.4"
    ip2 = IpRanges::Ip.new :number => '1.199.3.4'
    expect((@ip > ip2)).to be_truthy
  end

  it "knows 1.2.3.4 > 1.2.2.4" do
    @ip.number = "1.2.3.4"
    ip2 = IpRanges::Ip.new :number => '1.2.2.4'
    expect((@ip > ip2)).to be_truthy
  end

  it "knows 1.2.3.4 > 1.2.3.3" do
    @ip.number = "1.2.3.4"
    ip2 = IpRanges::Ip.new :number => '1.2.3.3'
    expect((@ip > ip2)).to be_truthy
  end

  it "knows 1.2.3.3 <= 1.2.3.4" do
    @ip.number = "1.2.3.3"
    ip2 = IpRanges::Ip.new :number => '1.2.3.4'
    expect((@ip > ip2)).to be_falsey
  end

  it "increments when 2nd tuple hits 255" do
    @ip.number = "1.255.255.255"
    expect(@ip.increment).to eq("2.0.0.0")
  end

  it "increments when 3rd tuple hits 255" do
    @ip.number = "1.2.255.255"
    expect(@ip.increment).to eq("1.3.0.0")
  end

  it "increments when last tuple hits 255" do
    @ip.number = "1.2.3.255"
    expect(@ip.increment).to eq("1.2.4.0")
  end

  it "increments last tuple" do
    @ip.number = '1.2.3.4'
    expect(@ip.increment).to eq("1.2.3.5")
  end

end
