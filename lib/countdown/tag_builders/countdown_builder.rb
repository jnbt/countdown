module Countdown
  module TagBuilders

    class CountdownBuilder
      include ::Countdown::ContentTags

      DEFAULT_DIRECTION  = :down
      DEFAULT_UNITS      = [:days, :hours, :minutes, :seconds]
      DEFAULT_SEPARATORS = { years: {value: "Y"}, months: {value: "M"}, weeks: {value: "w"}, days: {value: "d"}, hours: {value: "h"}, minutes: {value: "m"}, seconds: {value: "s"}, millis: {value: "ms"} }

      attr_reader :direction, :units, :separators, :timer

      def initialize(time, options)
        @direction  = options.delete(:direction) || DEFAULT_DIRECTION
        @units      = options.delete(:units) || DEFAULT_UNITS
        @separators = options.delete(:separators) || DEFAULT_SEPARATORS
        @timer      = CountdownTimer.new(time)
      end

      def to_html
        CountdownTag.new(direction).to_s do
          units.map do |unit|
            UnitContainerBuilder.new(unit, timer[unit], separators[unit]).to_html
          end.join
        end
      end
    end

  end
end