module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      MULTIPLIER = 86400000000000

      attr_accessor :from

      def initialize
        super 7, MULTIPLIER
      end

      def calculate(from, to)
        self.amount = DurationHelper.days(from, to)
        self.from   = from.to_datetime >> amount

        calculate_rest total_nanoseconds(from, to)
      end


      private

      def total_nanoseconds(from, to)
        DurationHelper.nanoseconds(from, to)
      end

    end

  end
end
