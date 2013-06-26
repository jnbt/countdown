module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable
      include TimeHelpers

      DEFAULT_MULTIPLIER = 1

      attr_reader   :position, :multiplier
      attr_accessor :amount, :rest

      def initialize(position, multiplier=DEFAULT_MULTIPLIER)
        @position   = position
        @multiplier = multiplier
        @amount     = 0
        @rest       = 0
      end

      def <=>(other)
        position <=> other.position
      end

      def calculate(total_nanoseconds)
        calculate_amount total_nanoseconds
        calculate_rest total_nanoseconds
      end

      private

      def calculate_amount(total_nanoseconds)
        self.amount = total_nanoseconds / multiplier
      end

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest(total_nanoseconds)
        self.rest = total_nanoseconds - amount_in_nanoseconds
      end

      def amount_in_nanoseconds
        amount * multiplier
      end

    end
  end

end
