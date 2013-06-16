module Countdown
  class Separator

    DEFAULT_ALIGN = :after
    attr_reader :value, :align

    def initialize(options={})
      @value = options.delete(:value)
      @align = options.delete(:align) || DEFAULT_ALIGN
    end

    def after?
      @align == DEFAULT_ALIGN
    end

    def before?
      !after?
    end

  end
end