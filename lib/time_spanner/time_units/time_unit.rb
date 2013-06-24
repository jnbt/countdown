module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable
      include TimeHelpers

      attr_reader   :position, :nano_multiplier
      attr_accessor :amount, :rest

      def initialize(position, nano_multiplier)
        @nano_multiplier  = nano_multiplier
        @position         = position
        @amount           = 0
        @rest             = 0
      end

      def calculate(duration)
        raise "Implement me in #{self.class.name}"
      end

      def <=>(other)
        position <=> other.position
      end


      private

      # The rest is needed to perform the calculation on the succeeding time units.
      def calculate_rest(nanoseconds)
        self.rest = nanoseconds - amount_in_nanoseconds
      end

      def amount_in_nanoseconds
        amount * nano_multiplier
      end

    end
  end

end
