module TimeSpanner
  module TimeUnits

    class Millennium < TimeUnit

      attr_accessor :from

      def initialize
        super 1
      end

      def calculate(from, to)
        millenniums, rest = DurationHelper.millenniums_with_rest(from, to)

        self.amount = millenniums
        self.rest   = rest
        self.from   = from.to_datetime >> amount*12000
      end

    end

  end
end
