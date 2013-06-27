module TimeSpanner
  module TimeUnits

    class Decade < TimeUnit

      attr_accessor :from

      def initialize
        super 3
      end

      def calculate(from, to)
        decades, rest = DurationHelper.decades_with_rest(from, to)

        self.amount = decades
        self.rest   = rest
        self.from   = from.to_datetime >> amount*120
      end

    end

  end
end
