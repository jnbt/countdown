module TimeSpanner
  module TimeUnits

    class Month < TimeUnit

      attr_accessor :from

      def initialize
        super 5
      end

      def calculate(from, to)
        months, rest = DurationHelper.months_with_rest(from, to)

        self.amount = months
        self.rest   = rest
        self.from   = from.to_datetime >> amount
      end

    end

  end
end
