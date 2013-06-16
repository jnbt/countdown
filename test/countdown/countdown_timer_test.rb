require 'test_helper'
require 'date'

module Countdown
  class CountdownTimerTest < TestCase

    before do
      now = DateTime.now
      h12m30 = now + 413 + (1.0/24)*12 + (1.0/24/2)

      @timer = CountdownTimer.new(h12m30)
    end

    it 'should calculate duration in ms' do
      assert_equal 35728200000, @timer.duration_in_ms
    end

    it 'should calculate years' do
      assert_equal 1, @timer[:years]
    end

    it 'should calculate months' do
      assert_equal 1, @timer[:months]
    end

    it 'should calculate weeks' do
      assert_equal 3, @timer[:weeks]
    end

    it 'should calculate days' do
      assert_equal 2, @timer[:days]
    end

    it 'should calculate hours' do
      assert_equal 12, @timer[:hours]
    end

    it 'should calculate minutes' do
      assert_equal 30, @timer[:minutes]
    end

    it 'should calculate seconds' do
      assert_equal 0, @timer[:seconds]
    end

    it 'should calculate millis' do
      assert_equal 0, @timer[:millis]
    end

  end
end