module TimeSpanner
  module TimeUnits

    class Year < TimeUnit

      attr_accessor :from

      def initialize
        super 4
      end

      def calculate(from, to)
        years, rest = DurationHelper.years_with_rest(from, to)

        self.amount = years
        self.rest   = rest
        self.from   = from.to_datetime >> amount*12
      end

    end

  end
end
