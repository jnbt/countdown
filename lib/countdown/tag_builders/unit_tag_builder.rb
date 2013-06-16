module Countdown
  module TagBuilders

    class UnitTagBuilder
      include ::Countdown::ContentTags

      attr_reader :unit, :time_unit, :unit_separator

      def initialize(unit, unit_value, separator_options)
        @unit           = unit
        @time_unit      = TimeUnitBuilder.new unit, unit_value
        @unit_separator = UnitSeparatorBuilder.new unit, separator_options
      end

      def to_html
        ContentTag.new(:span, class: unit.to_s).to_s do
          if unit_separator.after?
            [time_unit.to_html, unit_separator.to_html].join
          else
            [unit_separator.to_html, time_unit.to_html].join
          end
        end
      end
    end

  end
end