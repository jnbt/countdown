module TimeSpanner
  module TimeUnits

    class Decade < TimeUnit

      attr_accessor :from

      def initialize
        super 3
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = (to.year - from.year) / 10
        new_from    = (from.to_datetime >> amount*120).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
