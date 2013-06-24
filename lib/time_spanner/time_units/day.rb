module TimeSpanner
  module TimeUnits

    class Day < TimeUnit

      attr_reader :from, :to

      def initialize(from, to)
        super(7, 86400000000000)

        @from = from
        @to   = to
      end

      def calculate(duration)
        rest, nanoseconds  = duration.divmod(1000)
        rest, microseconds = rest.divmod(1000)
        rest, milliseconds = rest.divmod(1000)
        rest, seconds      = rest.divmod(60)
        rest, minutes      = rest.divmod(60)
        days, rest         = rest.divmod(24)
        self.amount        = days - leaps(from, to)

        calculate_rest(duration)
      end

    end

  end
end
