require 'test_helper'
require 'date'

module Countdown
  module ViewHelpers
    class ViewHelpersTest < TestCase

      before do
        @view = FakeView.new
      end

      it 'creates a default 24h countdown' do
        time = DateTime.now+1
        assert_equal "<div class=\"countdown\">#{time}</div>", @view.countdown(time)
      end

      it 'creates a default 24h countup' do
        time = DateTime.now+1
        assert_equal "<div class=\"countup\">#{time}</div>", @view.countup(time)
      end

    end
  end
end