module Countdown
  module ViewHelpers

    def countdown(time, options={})
      safe_buffer "<div class=\"countdown\">#{time}</div>"
    end

    def countup(time, options={})
      safe_buffer "<div class=\"countup\">#{time}</div>"
    end

    private

    def safe_buffer(string)
      defined?(Rails) ? ActiveSupport::SafeBuffer.new(string) : string
    end

  end
end