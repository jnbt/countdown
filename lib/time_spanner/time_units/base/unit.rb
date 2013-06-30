module TimeSpanner
  module TimeUnits

    class Unit
      include Comparable

      attr_reader   :position
      attr_accessor :amount, :rest

      def initialize(position)
        @position   = position
        @amount     = 0
        @rest       = 0
      end

      def <=>(other)
        position <=> other.position
      end

      def plural_name
        "#{self.class.name.split('::').last.downcase}s".to_sym
      end

    end
  end

end
