module TimeSpanner
  module TimeUnits

    class CalendarUnit < Unit

      attr_accessor :from

      def initialize(position)
        super position
      end

      def calculate(duration, to)
        self.from = to - (duration / 1000000000.to_r)

        self.amount = calculate_amount(from, to)
        self.rest   = calculate_rest(at_amount, to)
      end


      private

      def calculate_rest(from, to)
        Nanosecond.duration from, to
      end

    end
  end

end
