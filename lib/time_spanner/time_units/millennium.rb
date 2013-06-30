module TimeSpanner
  module TimeUnits

    class Millennium < CalendarUnit

      def initialize
        super 1
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = (to.year - from.year) / 1000
        new_from    = (from.to_datetime >> amount*12000).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
