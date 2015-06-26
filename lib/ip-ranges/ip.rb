module IpRanges

  # Class to represent a single IP number. Exposes methods for comparisons
  # with other IP numbers, as well as a method to increment the IP number.
  class Ip
    # String representation of this Ip number
    #
    # Example:
    #
    #   ip = Ip.new :number => '1.2.3.4'
    #   ip.number => '1.2.3.4'
    #
    attr_accessor :number

    # Arguments:
    #
    # *  A hash containing a single key whose value is the IP number as a string
    #
    # Example:
    #
    #   Ip.new(:number => '1.2.3.4')
    #
    def initialize(params = {})
      @number = params[:number]
    end

    # Example:
    # Ip.new(:number => '1.2.3.4').to_s => '1.2.3.4'
    def to_s
      number
    end

    # Arguments:
    #
    # * another Ip object
    #
    # Example:
    #
    #   ip1 = Ip.new(:number => '1.2.3.4')
    #   ip2 = Ip.new(:number => '1.2.3.5')
    #   ip3 = Ip.new(:number => '1.2.3.4')
    #
    #   ip1 == ip2 => false
    #   ip1 == ip3 => true
    def ==(ip)
      number == ip.number
    end

    # Arguments:
    #
    # * another Ip object
    #
    # Example:
    #
    #   ip1 = Ip.new(:number => '1.2.3.4')
    #   ip2 = Ip.new(:number => '1.2.3.5')
    #   ip3 = Ip.new(:number => '1.2.3.4')
    #
    #   ip1 >= ip2 => false
    #   ip2 >= ip3 => true
    #   ip1 >= ip3 => true
    def >=(ip)
      self == ip || self > ip
    end

    # Arguments:
    #
    # * another Ip object
    #
    # Example:
    #
    #   ip1 = Ip.new(:number => '1.2.3.4')
    #   ip2 = Ip.new(:number => '1.2.3.5')
    #
    #   ip1 > ip2 => false
    #   ip2 > ip1 => true
    #   ip2 > ip2 => false
    def >(ip)
      a1, b1, c1, d1 = tuples number
      a2, b2, c2, d2 = tuples ip.number
      if a1 > a2
        true
      elsif a1 < a2
        false
      elsif b1 > b2
        true
      elsif b1 < b2
        false
      elsif c1 > c2
        true
      elsif c1 < c2
        false
      else
        d1 > d2
      end
    end

    # Changes the 'number' property of this Ip
    # to the number before this one.
    #
    #   example:
    #
    #     ip = Ip.new(:number => '1.2.3.4')
    #     ip.number => '1.2.3.4'
    #     ip.decrement
    #     ip.number => '1.2.3.3'
    #
    def decrement
      a, b, c, d = tuples number
      if d > 0
        d -= 1
      else
        d = 255
        if c > 0
          c -= 1
        else
          c = 255
          if b > 0
            b -= 1
          else
            b = 255
            if a > 0
              a -= 1
            else
              raise "No more IPs"
            end
          end
        end
      end
      @number = [a, b, c, d].join('.')
    end

    # Changes the 'number' property of this Ip
    # to the next number after this one.
    #
    #   example:
    #
    #     ip = Ip.new(:number => '1.2.3.4')
    #     ip.number => '1.2.3.4'
    #     ip.increment
    #     ip.number => '1.2.3.5'
    #
    def increment
      a, b, c, d = tuples number
      if d < 255
        d += 1
      else
        d = 0
        if c < 255
          c += 1
        else
          c = 0
          if b < 255
            b += 1
          else
            b = 0
            if a < 255
              a += 1
            else
              raise "No more IPs"
            end
          end
        end
      end
      @number = [a, b, c, d].join('.')
    end

    private

    def tuples(string)
      string.split(/\./).map {|i| i.to_i}
    end

  end
end
