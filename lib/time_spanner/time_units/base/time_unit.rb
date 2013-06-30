module TimeSpanner
  module TimeUnits

    class TimeUnit < Unit

      DEFAULT_MULTIPLIER = 1

      attr_reader   :multiplier

      def initialize(position, multiplier=DEFAULT_MULTIPLIER)
        super position

        @multiplier = multiplier
      end

      def calculate(total_nanoseconds, to=nil)
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
