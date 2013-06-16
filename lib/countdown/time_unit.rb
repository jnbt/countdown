module Countdown
  class TimeUnit
    include ::Countdown::ContentTags

    attr_reader :unit, :value

    def initialize(unit, value)
      @unit  = unit
      @value = value
    end

    def to_html
      ContentTag.new(:span, class: "#{unit}-#{value}").to_s do
        value.to_s
      end
    end
  end
end