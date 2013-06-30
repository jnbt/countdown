module TimeSpanner
  module TimeUnits

    class TimeUnit < Unit

      attr_reader :multiplier

      def initialize(position, multiplier)
        super position

        @multiplier = multiplier
      end

      def calculate(duration, to=nil)
        @duration = duration

        calculate_amount
        calculate_rest
      end

      private

      def calculate_amount
        self.amount = ((duration * multiplier).round(12)).to_i
      end

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest
        self.rest = duration - amount_in_seconds
      end

      def amount_in_seconds
        amount.to_r / multiplier
      end

    end
  end

end
