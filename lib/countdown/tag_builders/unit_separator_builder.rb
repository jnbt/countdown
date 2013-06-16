module Countdown
  module TagBuilders

    class UnitSeparatorBuilder
      include ::Countdown::ContentTags

      DEFAULT_ALIGN       = :after
      DEFAULT_SINGULARIZE = false

      attr_reader :unit, :value, :align, :singular, :singularize

      def initialize(unit, options={})
        @unit        = unit
        @value       = options.delete(:value)
        @align       = options.delete(:align) || DEFAULT_ALIGN
        @singular    = options.delete(:singular)
        @singularize = options.delete(:singularize) || DEFAULT_SINGULARIZE
      end

      def after?
        @align == DEFAULT_ALIGN
      end

      def before?
        !after?
      end

      def singularize_value
        singular && singularize ? singular : value
      end

      def to_html
        ContentTag.new(:span, class: "#{unit}-separator").to_s do
          singularize_value.to_s
        end
      end

    end

  end
end