require 'test_helper'
require 'date'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      class DurationHelperTest < TestCase

        before do
          @now = DateTime.now
        end

        describe 'nanoseconds' do

          it 'should be Integer' do
            assert DurationHelper.nanoseconds(@now, @now+1).is_a?(Integer)
          end

          it 'calculates nanoseconds for 1 day in the future' do
            assert_equal 86400000000000, DurationHelper.nanoseconds(@now, @now+1)
          end

          it 'calculates nanoseconds for 1 day last week' do
            assert_equal 86400000000000, DurationHelper.nanoseconds(@now-7, @now-6)
          end

          it 'calculates nanoseconds for 1 day in the past' do
            assert_equal -86400000000000,  DurationHelper.nanoseconds(@now, @now-1)
          end

          it 'calculates nanoseconds for same timestamp' do
            assert_equal 0, DurationHelper.nanoseconds(@now, @now)
          end

        end

        describe 'days' do

          it 'calculates 0 days for given time span (same date)' do
            assert_equal 0, DurationHelper.days(@now, @now)
          end

          it 'calculates 1 day for given time span' do
            assert_equal 1, DurationHelper.days(@now, @now+1)
          end

          it 'calculates 2 days for given time span (2 days and something)' do
            assert_equal 2, DurationHelper.days(@now, @now+2)
          end

        end

        describe 'months' do

          it 'calculates 0 months for given time span (same date)' do
            assert_equal 0, DurationHelper.months(@now, @now)
          end

          it 'calculates 0 months for given time span (same month)' do
            assert_equal 0, DurationHelper.months(Date.parse('2013-01-01'), Date.parse('2013-01-31'))
          end

          it 'calculates 1 month for given time span (1 month)' do
            assert_equal 1, DurationHelper.months(Date.parse('2013-03-01'), Date.parse('2013-04-01'))
          end

          it 'calculates 1 month for given time span (30 days)' do
            assert_equal 1, DurationHelper.months(Date.parse('2013-06-02'), Date.parse('2013-07-02'))
          end

          # Should be equal in duration compared to 'calculates 1 month for given time span (30 days)'
          it 'calculates 1 month for given time span (1 month)' do
            assert_equal 1, DurationHelper.months(Date.parse('2013-06-01'), Date.parse('2013-07-01'))
          end

          it 'calculates 2 months for given time span (2 months and something)' do
            assert_equal 2, DurationHelper.months(Date.parse('2013-03-20'), Date.parse('2013-06-19'))
          end

          it 'calculates 2 months with  1 second rest in nanos' do
            assert_equal [2, 1000000000], DurationHelper.months_with_rest(DateTime.parse('2013-01-01 00:00:04'), DateTime.parse('2013-03-01 00:00:05'))
          end

          it 'calculates 0 months with  1 hour rest in nanos' do
            assert_equal [0, 3600000000000], DurationHelper.months_with_rest(DateTime.parse('2013-01-01 00:00:00'), DateTime.parse('2013-01-01 01:00:00'))
          end

          it 'calculates 0 months with  1 day rest in nanos' do
            assert_equal [0, 86400000000000], DurationHelper.months_with_rest(DateTime.parse('2013-01-01 00:00:00'), DateTime.parse('2013-01-02 00:00:00'))
          end

        end

        describe 'months and days' do

          it 'converts days to months and days by remaining_days given 0 days' do
            from    = DateTime.parse('2013-01-31 00:00:00')
            to      = DateTime.parse('2013-01-31 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [0, 0], months_days
          end

          it 'converts days to months and days by remaining_days given 1 day' do
            from = DateTime.parse('2013-01-31 00:00:00')
            to   = DateTime.parse('2013-02-01 00:00:00')

            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [0, 1], months_days
          end

          it 'converts days to months and days by remaining_days given 29 days' do
            from = DateTime.parse('2012-07-01 00:00:00')
            to   = DateTime.parse('2012-07-30 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [0, 29], months_days
          end

          it 'converts days to months and days by remaining_days given 30 days' do
            from = DateTime.parse('2012-06-02 00:00:00')
            to   = DateTime.parse('2012-07-02 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [1, 0], months_days
          end


          it 'converts days to months and days by remaining_days given 1 month' do
            from = DateTime.parse('2012-06-01 00:00:00')
            to   = DateTime.parse('2012-07-01 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [1, 0], months_days
          end

          it 'converts days to months and days by remaining_days given 1 month and 1 day' do
            from = DateTime.parse('2012-06-01 00:00:00')
            to   = DateTime.parse('2012-07-02 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [1, 1], months_days
          end

          it 'converts days to months and days by remaining_days given 1 month and 1 day (july)' do
            from = DateTime.parse('2012-07-01 00:00:00')
            to   = DateTime.parse('2012-08-02 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [1, 1], months_days
          end

          it 'converts days to months and days by remaining_days given 1 month and 2 days' do
            from = DateTime.parse('2012-06-01 00:00:00')
            to   = DateTime.parse('2012-07-03 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [1, 2], months_days
          end

          it 'converts days to months and days by remaining_days given 94 days' do
            from = DateTime.parse('2013-06-01 00:00:00')
            to   = DateTime.parse('2013-09-03 00:00:00')
            months_days = DurationHelper.months_with_days(from, to)

            assert_equal [3, 2], months_days
          end

        end

        it 'calculates years with rest (1 nanosecond)' do
          from         = DateTime.parse('3013-01-01 00:00:00')
          target_years = DateTime.parse('3015-01-01 00:00:00')
          to           = Time.at(target_years.to_time.to_r, 0.001)

          assert_equal [2, 1], DurationHelper.years_with_rest(from, to)
        end

        it 'calculates millenniums with rest (1 nanosecond)' do
          from                  = DateTime.parse('3013-01-01 00:00:00')
          target_millenniums    = DateTime.parse('5013-01-01 00:00:00')
          to                    = Time.at(target_millenniums.to_time.to_r, 0.001)

          assert_equal [2, 1], DurationHelper.millenniums_with_rest(from, to)
        end

        # TODO: fails! why are 6h calculated in addition to 1 century?
        # Test with decades and year first
        # We dont have this problem on years with months, do we?
        it 'calculates millenniums with rest (1 century in nanoseconds)' do
          from = DateTime.parse('3013-01-01 00:00:00')
          to   = DateTime.parse('5113-01-01 00:00:00')

          assert_equal [2, 3155695200000000000], DurationHelper.millenniums_with_rest(from, to)
        end

      end
    end
  end
end