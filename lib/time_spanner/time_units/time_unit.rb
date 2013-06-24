module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable

      attr_reader   :position
      attr_accessor :amount, :rest

      def initialize(position)
        @position = position
        @amount   = 0
        @rest     = 0
      end

      def calculate(duration)
        raise "Implement me in #{self.class.name}"
      end

      def <=>(other)
        position <=> other.position
      end

    end
  end

end
