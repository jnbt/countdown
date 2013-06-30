module TimeSpanner
  module TimeUnits

    class Decade < TimeUnit

      attr_accessor :from

      def initialize
        super 3
      end

      def calculate(from, to)
        self.amount = (to.year - from.year) / 10
        self.from   = from.to_datetime >> amount*120
        self.rest   = Nanosecond.duration self.from.to_time, to
      end

    end

  end
end
