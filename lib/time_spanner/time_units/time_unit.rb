module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable

      attr_reader :name, :position
      attr_accessor :amount, :rest

      def initialize(position)
        @position = position
        @name     = to_sym
        @amount   = 0
        @rest     = 0
      end

      def calculate(duration)
        raise "Implement me in #{self.class.name}"
      end

      def <=>(other)
        position <=> other.position
      end

      def to_sym
        "#{self.class.name.split('::').last.downcase}s".to_sym # Will not work on century!
      end

    end
  end

end
