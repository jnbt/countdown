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

        assert @view.countdown(time).is_a?(String)
      end

      it 'creates a default 24h countup' do
        time = DateTime.now+1

        assert @view.countup(time).is_a?(String)
      end

    end
  end
end