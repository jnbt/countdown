module TimeSpanner
  module TimeUnits

    class TimeUnit
      include Comparable

      DEFAULT_ORDER = TimeUnitCollection::DEFAULT_ORDER

      attr_reader :name, :position
      attr_accessor :amount, :rest

      def initialize(name)
        @name   = name
        @amount = 0
        @rest = 0
      end

      def calculate(duration, &block)
        raise "Implement me in #{self.class.name}"
      end

      def <=>(other)
        DEFAULT_ORDER.index(name) <=> DEFAULT_ORDER.index(other.name)
      end

    end
  end

end
