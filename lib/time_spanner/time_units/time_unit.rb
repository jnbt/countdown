module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable
      include TimeHelpers

      attr_reader   :position
      attr_accessor :amount, :rest

      def initialize(position)
        @position = position
        @amount   = 0
        @rest     = 0
      end

      def <=>(other)
        position <=> other.position
      end

      def calculate(total_nanoseconds)
        calculate_amount(total_nanoseconds)
        calculate_rest total_nanoseconds
      end

      private

      def calculate_amount(total_nanoseconds)
        self.amount = total_nanoseconds / self.class::MULTIPLIER
      end

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest(total_nanoseconds)
        self.rest = total_nanoseconds - amount_in_nanoseconds
      end

      def amount_in_nanoseconds
        amount * self.class::MULTIPLIER
      end

      def total_nanoseconds(from, to)
        DurationHelper.nanoseconds(from, to)
      end

    end
  end

end
