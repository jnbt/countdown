module TimeSpanner
  module TimeUnits

    class Year < TimeUnit

      attr_accessor :from

      def initialize
        super 4
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = to.year - from.year
        new_from    = (from.to_datetime >> amount*12).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
