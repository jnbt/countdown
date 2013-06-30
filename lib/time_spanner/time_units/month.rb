module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      attr_accessor :from

      def initialize
        super 5
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = (to.year*12 + to.month) - (from.year*12 + from.month) - (to.day < from.day ? 1 : 0)
        new_from    = (from.to_datetime >> amount).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

    end

  end
end
