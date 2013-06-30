module TimeSpanner
  module TimeUnits

    class TimeUnit < Unit

      DEFAULT_MULTIPLIER = 1

      attr_reader :multiplier

      def initialize(position, multiplier=DEFAULT_MULTIPLIER)
        super position

        @multiplier = multiplier
      end

      def calculate(duration, to=nil)
        calculate_amount duration
        calculate_rest duration
      end

      private

      def calculate_amount(duration)
        self.amount = duration / multiplier
      end

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest(duration)
        self.rest = duration - amount_in_nanoseconds
      end

      def amount_in_nanoseconds
        amount * multiplier
      end

    end
  end

end
