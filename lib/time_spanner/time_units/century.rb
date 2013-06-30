module TimeSpanner
  module TimeUnits

    class Century < TimeUnit

      def initialize
        super 2
      end

      def calculate(duration, to)
        from = to - (duration / 1000000000.to_r)

        self.amount = (to.year - from.year) / 100
        new_from    = (from.to_datetime >> amount*1200).to_time
        self.rest   = Nanosecond.duration new_from, to
      end

      # Overwrite!
      def plural_name
        :centuries
      end

    end

  end
end
