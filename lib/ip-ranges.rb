require 'rubygems'
require 'netaddr'

# Manipulate and compare ranges of Ip numbers.
# In particular, this gem allows you to specify
# multiple Ip ranges, in a variety of formats,
# and compare them for overlaps, equivalence and
# containment (i.e. range1 contains all of range2)
#
# :title: IpRanges Gem
# Author:: David Salgado (mailto:david@digitalronin.com)
# Copyright:: Copyright (c) 2011 David Salgado
# License::   Distributes under the same terms as Ruby
module IpRanges
end

libdir = File.join(File.dirname(__FILE__), 'ip-ranges')
require File.join(libdir, 'ip')
require File.join(libdir, 'range')
