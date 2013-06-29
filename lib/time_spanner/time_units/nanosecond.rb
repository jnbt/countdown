module TimeSpanner
  module TimeUnits

    class Nanosecond < TimeUnit

      def initialize
        super 13
      end

      # Returns number of nanoseconds for given time span as Integer.
      def self.duration(from, to)
        ((to.to_time.to_r - from.to_time.to_r).round(9) * 1000000000).to_i
      end

    end

  end
end
