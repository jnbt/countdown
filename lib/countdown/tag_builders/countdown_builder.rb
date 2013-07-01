# encoding: UTF-8
# TODO: 'railsify' only here -> force Rails DateTime objects to convert to time; safe_buffer

module Countdown
  module TagBuilders

    class CountdownBuilder
      include ::Countdown::ContentTags
      include TimeSpanner

      DEFAULT_DIRECTION  = :down
      DEFAULT_STEPS      = :seconds
      DEFAULT_UNITS      = [:days, :hours, :minutes, :seconds]
      DEFAULT_SEPARATORS = { millenniums: {value: 'MN'}, centuries: {value: 'C'}, decades: {value: 'D'}, years: {value: 'Y'}, months: {value: 'M'}, weeks: {value: 'w'}, days: {value: 'd'}, hours: {value: 'h'}, minutes: {value: 'm'}, seconds: {value: 's'}, milliseconds: {value: 'ms'}, microseconds: {value: 'µs'}, nanoseconds: {value: 'ns'} }

      attr_reader :direction, :steps, :units, :separators, :time_span

      def initialize(options)
        now  = Time.now
        from = options.delete(:from) || now
        to   = options.delete(:to) || now

        @direction  = options.delete(:direction) || DEFAULT_DIRECTION
        @steps      = options.delete(:steps) || DEFAULT_STEPS
        @units      = options.delete(:units) || DEFAULT_UNITS
        @separators = options.delete(:separators) || DEFAULT_SEPARATORS
        @time_span  = TimeSpan.new(from, to, units)
      end

      def attributes
        { :class => 'countdown', :'data-direction' => direction.to_s, :'data-steps' => steps.to_s }
      end

      def to_html
        ContentTag.new(:div, attributes).to_s do
          units.map do |unit|
            UnitContainerBuilder.new(unit, time_span[unit], separators[unit]).to_html
          end.join
        end
      end

    end

  end
end