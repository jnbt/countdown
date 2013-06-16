module Countdown
  module TagBuilders

    class UnitSeparatorBuilder
      include ::Countdown::ContentTags

      DEFAULT_ALIGN = :after
      attr_reader :value, :align, :unit

      def initialize(unit, options={})
        @unit  = unit
        @value = options.delete(:value)
        @align = options.delete(:align) || DEFAULT_ALIGN
      end

      def after?
        @align == DEFAULT_ALIGN
      end

      def before?
        !after?
      end

      def to_html
        ContentTag.new(:span, class: "#{unit}-separator").to_s do
          value.to_s
        end
      end
    end

  end
end