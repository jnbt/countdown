module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable

      attr_reader   :position, :duration_multiplier
      attr_accessor :amount, :rest

      def initialize(position, duration_multiplier)
        @duration_multiplier = duration_multiplier
        @position            = position
        @amount              = 0
        @rest                = 0
      end

      def calculate(duration)
        raise "Implement me in #{self.class.name}"
      end

      def <=>(other)
        position <=> other.position
      end

      private

      def calculate_rest(nanoseconds)
        self.rest = nanoseconds - amount_to_nanoseconds
      end

      def amount_to_nanoseconds
        amount * duration_multiplier
      end

    end
  end

end
