module Countdown
  module ViewHelpers
    include ::Countdown::TagBuilders

    def countdown(options={})
      safe_buffer CountdownBuilder.new(options).to_html
    end

    def countup(options={})
      safe_buffer CountdownBuilder.new(options.merge(direction: :up)).to_html
    end


    private

    def safe_buffer(string)
      defined?(Rails) ? ActiveSupport::SafeBuffer.new(string) : string
    end

  end
end