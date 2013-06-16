require 'test_helper'
require 'date'

module Countdown
  module Counters
    class CountdownTimerTest < TestCase

      before do
        time = DateTime.now+1
        @timer = CountdownTimer.new(time)
      end

      it 'should calculate years' do
        assert_equal 1, @timer[:years]
      end

      it 'should calculate months' do
        assert_equal 1, @timer[:months]
      end

      it 'should calculate weeks' do
        assert_equal 1, @timer[:weeks]
      end

      it 'should calculate days' do
        assert_equal 1, @timer[:days]
      end

      it 'should calculate hours' do
        assert_equal 1, @timer[:hours]
      end

      it 'should calculate minutes' do
        assert_equal 1, @timer[:minutes]
      end

      it 'should calculate seconds' do
        assert_equal 1, @timer[:seconds]
      end

      it 'should calculate millis' do
        assert_equal 1, @timer[:millis]
      end

    end
  end
end