module Countdown
  module TagBuilders

    class CountdownBuilder
      include ::Countdown::ContentTags

      DEFAULT_DIRECTION  = :down
      DEFAULT_STEPS      = :seconds
      DEFAULT_UNITS      = [:days, :hours, :minutes, :seconds]
      DEFAULT_SEPARATORS = { years: {value: "Y"}, months: {value: "M"}, weeks: {value: "w"}, days: {value: "d"}, hours: {value: "h"}, minutes: {value: "m"}, seconds: {value: "s"}, millis: {value: "ms"} }

      attr_reader :direction, :steps, :units, :separators, :timer

      def initialize(time, options)
        @direction  = options.delete(:direction) || DEFAULT_DIRECTION
        @steps      = options.delete(:steps) || DEFAULT_STEPS
        @units      = options.delete(:units) || DEFAULT_UNITS
        @separators = options.delete(:separators) || DEFAULT_SEPARATORS
        @timer      = CountdownTimer.new(time)
      end

      def attributes
        { :class => "countdown", :'data-direction' => direction.to_s, :'data-steps' => steps.to_s }
      end

      def to_html
        ContentTag.new(:div, attributes).to_s do
          units.map do |unit|
            UnitContainerBuilder.new(unit, timer[unit], separators[unit]).to_html
          end.join
        end
      end
    end

  end
end