require 'test_helper'

module Countdown
  module ViewHelpers
    class ViewHelpersTest < TestCase

      before do
        @view = FakeView.new
      end

      it 'creates a default 24h countdown' do
        from = Time.now
        to   = from + 1

        assert @view.countdown(from: from, to: to).is_a?(String)
      end

      it 'creates a default 24h countup' do
        from = Time.now
        to   = from + 1

        assert @view.countup(from: from, to: to).is_a?(String)
      end

    end
  end
end