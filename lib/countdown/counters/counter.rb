module Countdown
  module Counters

    class Counter
      include ::Countdown::ContentTags

      DEFAULT_DIRECTION  = :down
      DEFAULT_UNITS      = [:days, :hours, :minutes, :seconds]
      DEFAULT_SEPARATORS = { years: {value: "Y"}, months: {value: "M"}, weeks: {value: "w"}, days: {value: "d"}, hours: {value: "h"}, minutes: {value: "m"}, seconds: {value: "s"}, millis: {value: "ms"} }

      attr_reader :direction, :units, :separators, :time

      def initialize(time, options)
        @direction  = options.delete(:direction) || DEFAULT_DIRECTION
        @units      = options.delete(:units) || DEFAULT_UNITS
        @separators = options.delete(:separators) || DEFAULT_SEPARATORS
        @time       = time
      end

      def to_html
        CountdownTag.new(direction).to_s do
          units.map do |unit|
            html = ""

            separator_tag = ContentTag.new(:span, class: "#{unit}-separator").to_s do
              separators[unit][:value]
            end

            unit_tag = ContentTag.new(:span, class: "#{unit} #{unit}-#{time_to_unit(unit)}").to_s do
              time_to_unit(unit)
            end

            html << separator_tag
            html << unit_tag
          end.join
        end
      end

      def time_to_unit(unit)
        1.to_s
      end
    end

  end
end