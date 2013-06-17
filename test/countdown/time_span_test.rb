require 'test_helper'
require 'date'
require 'timecop'

module Countdown
  class TimeSpanTest < TestCase

    before do
      @now = DateTime.now
      @h12m30 = @now + 413 + (1.0/24)*12 + (1.0/24/2)

      @time_span = TimeSpan.new(@now, @h12m30)
    end

    describe 'duration in millis' do

      it 'should calculate duration for 1 day in the future' do
        assert_equal 86400000, TimeSpan.new(@now, @now+1).duration_in_ms
      end

      it 'should calculate duration for 1 day in the past' do
        assert_equal -86400000, TimeSpan.new(@now, @now-1).duration_in_ms
      end

      it 'should calculate duration for same timestamp' do
        assert_equal 0, TimeSpan.new(@now, @now).duration_in_ms
      end

      it 'should calculate duration for last week' do
        assert_equal 86400000, TimeSpan.new(@now-7, @now-6).duration_in_ms
      end

    end

    it 'should calculate years' do
      assert_equal 1, @time_span[:years]
    end

    it 'should calculate months' do
      assert_equal 1, @time_span[:months]
    end

    it 'should calculate weeks' do
      assert_equal 3, @time_span[:weeks]
    end

    it 'should calculate days' do
      assert_equal 2, @time_span[:days]
    end

    it 'should calculate hours' do
      assert_equal 12, @time_span[:hours]
    end

    it 'should calculate minutes' do
      assert_equal 30, @time_span[:minutes]
    end

    it 'should calculate seconds' do
      assert_equal 0, @time_span[:seconds]
    end

    it 'should calculate millis' do
      assert_equal 0, @time_span[:millis]
    end

  end
end