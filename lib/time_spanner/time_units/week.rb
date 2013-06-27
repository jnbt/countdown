module TimeSpanner
  module TimeUnits

    class Week < TimeUnit

      attr_accessor :from

      def initialize
        super 6
      end

      def calculate(from, to)
        weeks, rest = DurationHelper.weeks_with_rest(from, to)

        self.amount = weeks
        self.rest   = rest
        self.from   = from.to_datetime + amount * 7
      end

    end

  end
end
