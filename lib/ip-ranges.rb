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

  # Checks multiple ranges of IP numbers for uniqueness (in the sense that a given IP number
  # should only appear once within the set of all supplied ranges).
  #
  # Arguments:
  # * An array of strings that define single IP numbers or ranges (in dotted or CIDR notation)
  #
  # Returns:
  # * An array of strings describing any overlaps, equivalences and containments which occur in the list (see the specs for details)
  #
  def check_for_overlaps(list)
    rtn = []
    while list.any?
      test_range = list.shift
      test = Range.new :range => test_range
      list.each do |range| 
        i = Range.new :range => range
        if test.overlaps_range?(i)
          if test == i
            rtn << "#{test_range} equals range #{range}"
          elsif test.contains_range?(i)
            rtn << "#{test_range} contains range #{range}"
          elsif i.contains_range?(test)
            rtn << "#{test_range} is contained by range #{range}"
          else
            rtn << "#{test_range} overlaps with #{range}"
          end
        end
      end
    end
    rtn
  end
end

libdir = File.join(File.dirname(__FILE__), 'ip-ranges')
require File.join(libdir, 'ip')
require File.join(libdir, 'range')
