module TimeSpanner
  module TimeUnits

    class Year < TimeUnit

      attr_accessor :from

      def initialize
        super 4
      end

      def calculate(from, to)
        self.amount = to.year - from.year
        self.from   = from.to_datetime >> amount*12
        self.rest   = Nanosecond.duration self.from, to
      end

    end

  end
end
