module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable
      include TimeHelpers

      DEFAULT_MULTIPLIER = 1

      attr_reader   :position, :nano_multiplier
      attr_accessor :amount, :rest

      def initialize(position, nano_multiplier=DEFAULT_MULTIPLIER)
        @nano_multiplier = nano_multiplier
        @position        = position
        @amount          = 0
        @rest            = 0
      end

      def <=>(other)
        position <=> other.position
      end


      private

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest(total_nanoseconds)
        self.rest = total_nanoseconds - amount_in_nanoseconds
      end

      def amount_in_nanoseconds
        amount * nano_multiplier
      end

      def total_nanoseconds(from, to)
        DurationHelper.nanoseconds(from, to)
      end

    end
  end

end
