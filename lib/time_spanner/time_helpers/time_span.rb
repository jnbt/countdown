require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/duration_helper'
require 'time_spanner/time_helpers/time_unit_collection'

module TimeSpanner
  module TimeHelpers

    class TimeSpan

      DEFAULT_UNITS = TimeUnitCollection::AVAILABLE_UNITS

      attr_reader :from, :to, :units

      attr_reader :nanos
      attr_reader :micros
      attr_reader :millis
      attr_reader :seconds
      attr_reader :minutes
      attr_reader :hours
      attr_reader :days
      attr_reader :weeks
      attr_reader :months
      attr_reader :years
      attr_reader :decades
      attr_reader :centuries
      attr_reader :millenniums

      def initialize(from, to, units=[])
        @from           = from
        @to             = to

        unit_collection = TimeUnitCollection.new(units)
        @units          = unit_collection.sort.map(&:name)

        delegate_calculation
      end

      def delegate_calculation
        case units
          when TimeUnitCollection::AVAILABLE_UNITS
            calculate_all_units
          when [:nanos]
            @nanos = total_nanos
          when [:days]
            @days = total_days
          when [:months]
            @months = total_months
          when [:months, :days, :hours]
            calculate_hours_with_days_with_months
          when ([:days, :months] - units).empty?
            @days, @months = DurationHelper.months_with_days(from, to).reverse
        end
      end

      def duration
        to.to_time.to_r - from.to_time.to_r
      end

      def total_nanos
        (duration.round(9) * 1000000000).to_i
      end

      def total_micros
        total_nanos / 1000
      end

      def total_millis
        total_micros / 1000
      end

      def total_seconds
        total_millis / 1000
      end

      def total_minutes
        total_seconds / 60
      end

      def total_hours
        total_minutes / 60
      end

      def total_days
        total_hours / 24 - leaps
      end

      def total_weeks
        (total_days + leaps) / 7
      end

      def total_months
        DurationHelper.months from, to
      end

      def total_years
        total_days / 365
      end

      def total_decades
        total_years / 10
      end

      def total_centuries
        total_decades / 10
      end

      def total_millenniums
        total_centuries / 10
      end

      def calculate_all_units
        remaining_micros, @nanos    = total_nanos.divmod(1000)
        remaining_millis, @micros   = remaining_micros.divmod(1000)
        remaining_seconds, @millis  = remaining_millis.divmod(1000)
        remaining_minutes, @seconds = remaining_seconds.divmod(60)
        remaining_hours, @minutes   = remaining_minutes.divmod(60)
        remaining_days, @hours      = remaining_hours.divmod(24)

        remaining_days -= leaps

        remaining_years, remaining_days = remaining_days.divmod(365)

        @months, days = DurationHelper.months_with_days(to.to_date-remaining_days, to)

        remaining_decades, @years     = remaining_years.divmod(10)
        remaining_centuries, @decades = remaining_decades.divmod(10)
        @millenniums, @centuries      = remaining_centuries.divmod(10)

        @weeks, @days  = days.divmod(7)
      end

      def calculate_hours_with_days_with_months
        remaining_days, @hours = total_hours.divmod(24)
        remaining_days -= leaps
        @months, @days = DurationHelper.months_with_days(to.to_date-remaining_days, to)
      end


      private

      def leaps
        DateHelper.leap_count from, to
      end

    end
  end

end