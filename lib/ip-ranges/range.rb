module IpRanges

  # Class to represent a range of IP numbers. 
  # Range objects are instantiated from a string which may be a single 
  # Exposes methods to compare this range with another range, and to 
  # iterate through all IP numbers in the range.
  class Range
    # First IP number in the range, as an Ip object
    attr_accessor :first

    # Last IP number in the range, as an Ip object
    attr_accessor :last

    SINGLE_IP = /^\d+\.\d+\.\d+\.\d+$/
    DOTTED_RANGE = /^(\d+\.\d+\.\d+\.\d+)\.\.(\d+\.\d+\.\d+\.\d+)$/
    CIDR_RANGE = %r[/]

    BATCHSIZE = 250
    PAUSE = 2

    # Instatiate a range from a string representation which can be a single
    # Ip number, a dotted range or a CIDR range
    #
    # Arguments:
    # * A +Hash+ with a single key ':range' whose value is a string defining the range.
    #
    # Examples:
    #
    #   IpRanges::Range.new :range => '1.2.3.4' => a range containing one Ip
    #   IpRanges::Range.new :range => '1.2.3.4 .. 1.2.3.5' => a range containing two Ip numbers (spaces around the '..' are ignored)
    #   IpRanges::Range.new :range => '1.2.3.0/24' => a range containing 256 Ip numbers (1.2.3.0 .. 1.2.3.255)
    #
    def initialize(params)
      string = params[:range].gsub(' ', '')
      case string
      when SINGLE_IP
        @first = Ip.new :number => string
        @last = Ip.new :number => string
      when DOTTED_RANGE
        @first = Ip.new :number => $1
        @last = Ip.new :number => $2
      when CIDR_RANGE
        begin
          cidr = NetAddr::CIDR.create(string)
          @first = Ip.new :number => cidr.first
          @last = Ip.new :number => cidr.last
        rescue Exception => e
          puts "Error creating CIDR range from: #{string}"
          raise e
        end
      end
    end

    # Returns the last Ip object in this range.
    def last
      @last
    end

    # Returns the first Ip object in this range.
    def first
      @first
    end

    # Arguments
    # * A +Range+ object
    # True if this range is equivalent to the passed-in range.
    def ==(range)
      first == range.first && last == range.last
    end

    # Arguments
    # * A +Range+ object
    # True if this range intersects with the passed-in range.
    def overlaps_range?(range)
      contains_ip?(range.first) || contains_ip?(range.last) || range.contains_ip?(first) || range.contains_ip?(last)
    end

    # Arguments
    # * A +Range+ object
    # True if this range completely contains the passed-in range.
    def contains_range?(range)
      contains_ip?(range.first) && contains_ip?(range.last)
    end

    # Arguments
    # * A +String+ or an +Ip+ object
    # True if the range contains the IP
    def contains_ip?(ip)
      test = ip.kind_of?(String) ? Ip.new(:number => ip) : ip
      test >= @first && @last >= test
    end

    # Yields each IP in the range, in turn, as an Ip object.
    def each_ip
      @counter = 0 # for throttling
      ip = first
      while last >= ip
        yield ip.dup
        ip.increment
        throttle
      end
    end

    private

    def throttle
      @counter += 1
      if @counter % BATCHSIZE == 0
        take_a_nap
      end
    end

    def take_a_nap
      log "Counter: #{$counter}, sleeping for #{PAUSE} seconds" if $verbose
      sleep PAUSE
    end

  end
end
