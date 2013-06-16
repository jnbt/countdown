module Countdown
  module ViewHelpers
    include ::Countdown::TagBuilders

    def countdown(time, options={})
      safe_buffer CountdownBuilder.new(time, options).to_html
    end

    def countup(time, options={})
      safe_buffer CountdownBuilder.new(time, options.merge(direction: :up)).to_html
    end

    private

    def safe_buffer(string)
      defined?(Rails) ? ActiveSupport::SafeBuffer.new(string) : string
    end

  end
end