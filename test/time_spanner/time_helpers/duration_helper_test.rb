require 'test_helper'
require 'date'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      class DurationHelperTest < TestCase

        describe 'days' do

          it 'calculates 0 days for given time span (same date)' do
            assert_equal 0, DurationHelper.days(Date.parse('2013-02-01'), Date.parse('2013-02-01'))
          end

          it 'calculates 1 day for given time span' do
            assert_equal 1, DurationHelper.days(Date.parse('2013-03-20'), Date.parse('2013-03-21'))
          end

          it 'calculates 2 days for given time span (2 days and something)' do
            assert_equal 2, DurationHelper.days(Date.parse('2013-03-20'), Date.parse('2013-03-22'))
          end

        end

        describe 'months' do

          it 'calculates 0 months for given time span (same date)' do
            assert_equal 0, DurationHelper.months(Date.parse('2013-02-01'), Date.parse('2013-02-01'))
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

      end
    end
  end
end