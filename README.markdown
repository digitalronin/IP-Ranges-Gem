Compare IP ranges
=================

This gem allows you to take multiple IP ranges, which may be defined in several ways (as a single IP number, a dotted string or a CIDR range), and compare them against each other to check for uniqueness, overlaps, equivalence or one range containing another.

Example
=======

    r1 = IpRanges::Range.new :range => '1.2.3.4..1.2.3.5'
    r2 = IpRanges::Range.new :range => '1.2.3.0/24'
    
    r2.overlaps_range?(r1) => true
    r2.contains_range?(r1) => true
    r2 == r1               => false
    
    list = [
      '1.2.3.4..1.2.3.5',
      '1.2.3.0/24'
    ]
    
    IpRanges::Range.check_for_overlaps list 
      => ["1.2.3.4..1.2.3.5 is contained by range 1.2.3.0/24"] 

MIT License
===========

(c) David Salgado 2011, or whenever

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
