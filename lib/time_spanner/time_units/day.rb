module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      attr_accessor :from

      def initialize
        super 7
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = (to.to_time - from.to_time).to_i / 86400
        new_from    = (from.to_datetime + amount).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
