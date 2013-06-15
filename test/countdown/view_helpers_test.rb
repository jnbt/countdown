require 'test_helper'
require 'date'

module Countdown
  module ViewHelpers
    class ViewHelpersTest < TestCase

      before do
        @view = FakeView.new
      end

      it 'creates a default 24h countdown' do
        assert_equal '', @view.countdown(DateTime.now+1)
      end

    end
  end
end