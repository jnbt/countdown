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
        expected = "<div class=\"countdown\"><span class=\"days-separator\">d</span><span class=\"days days-1\">1</span><span class=\"hours-separator\">h</span><span class=\"hours hours-1\">1</span><span class=\"minutes-separator\">m</span><span class=\"minutes minutes-1\">1</span><span class=\"seconds-separator\">s</span><span class=\"seconds seconds-1\">1</span></div>"
        assert_equal expected, @view.countdown(time)
      end

      it 'creates a default 24h countup' do
        time = DateTime.now+1
        expected = "<div class=\"countup\"><span class=\"days-separator\">d</span><span class=\"days days-1\">1</span><span class=\"hours-separator\">h</span><span class=\"hours hours-1\">1</span><span class=\"minutes-separator\">m</span><span class=\"minutes minutes-1\">1</span><span class=\"seconds-separator\">s</span><span class=\"seconds seconds-1\">1</span></div>"
        assert_equal expected, @view.countup(time)
      end

    end
  end
end