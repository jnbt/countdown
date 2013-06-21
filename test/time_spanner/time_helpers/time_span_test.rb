require 'test_helper'
require 'date'

module TimeSpanner
  module TimeHelpers

    class TimeSpanTest < TestCase

      before do
        @now = DateTime.now
      end

      describe 'nanos' do

        it 'should calculate duration for 1 day in the future' do
          assert_equal 86400000000000, TimeSpan.new(@now, @now+1).nanos
        end

        it 'should calculate duration for 1 day in the past' do
          assert_equal -86400000000000, TimeSpan.new(@now, @now-1).nanos
        end

        it 'should calculate duration for same timestamp' do
          assert_equal 0, TimeSpan.new(@now, @now).nanos
        end

        it 'should calculate duration for last week' do
          assert_equal 86400000000000, TimeSpan.new(@now-7, @now-6).nanos
        end

      end

      describe 'days' do

        it 'sums up days by upcoming months' do
          from = DateTime.parse("2013-06-17 00:00:00")
          to   = DateTime.parse("2013-12-02 00:00:00")

          assert_equal 167, TimeSpan.days_in_timeframe(from, to)
        end

      end

      describe 'months and days' do

        it 'converts days to months and days by remaining_days given 0 days' do
          target_time    = DateTime.parse("2013-01-31 00:00:00")
          remaining_days = 0
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [0, 0], months_days
        end

        it 'converts days to months and days by remaining_days given 1 day' do
          target_time    = DateTime.parse("2013-02-01 00:00:00")
          remaining_days = 1
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [0, 1], months_days
        end

        it 'converts days to months and days by remaining_days given 29 days' do
          target_time    = DateTime.parse("2012-07-01 00:00:00")
          remaining_days = 29
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [0, 29], months_days
        end

        it 'converts days to months and days by remaining_days given 30 days' do
          target_time    = DateTime.parse("2012-07-02 00:00:00")
          remaining_days = 30
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [1, 0], months_days
        end

        # Should be equal in duration compared to 'converts days to months and days by remaining_days given 30 days'
        it 'converts days to months and days by remaining_days given 1 month' do
          target_time    = DateTime.parse("2012-07-01 00:00:00")
          remaining_days = 30
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [1, 0], months_days
        end

        it 'converts days to months and days by remaining_days given 1 month and 1 day' do
          target_time    = DateTime.parse("2012-07-02 00:00:00")
          remaining_days = 31
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [1, 1], months_days
        end

        it 'converts days to months and days by remaining_days given 1 month and 2 days' do
          target_time    = DateTime.parse("2012-07-03 00:00:00")
          remaining_days = 32
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [1, 2], months_days
        end

        it 'converts days to months and days by remaining_days given 94 days' do
          target_time    = DateTime.parse("2013-09-03 00:00:00")
          remaining_days = 94
          months_days    = TimeSpan.months_and_days(target_time, remaining_days)

          assert_equal [3, 2], months_days
        end

      end

    end

  end
end