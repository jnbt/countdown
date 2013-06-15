module Countdown
  module ViewHelpers

    def countdown(time, options={})
      "<div class=\"countdown\">#{time}</div>"
    end

    def countup(time, options={})
      "<div class=\"countup\">#{time}</div>"
    end

  end
end