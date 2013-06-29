module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      attr_accessor :from

      def initialize
        super 5
      end

      def calculate(from, to)
        self.amount = (to.year*12 + to.month) - (from.year*12 + from.month) - (to.day < from.day ? 1 : 0)
        self.from   = from.to_datetime >> amount
        self.rest   = Nanosecond.duration self.from, to
      end

    end

  end
end
