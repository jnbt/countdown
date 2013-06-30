module TimeSpanner
  module TimeUnits

    class Week < CalendarUnit

      def initialize
        super 6
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = ((to.to_datetime - from.to_datetime) / 7).to_i
        new_from    = (from.to_datetime + amount * 7).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
