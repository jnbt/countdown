require 'test_helper'
require 'date'

module TimeSpanner
  module TimeHelpers
    module DurationHelper

      class DurationHelperTest < TestCase

        describe 'months' do

          it 'calculates 0 months for given time span (same date)' do
            assert_equal 0, DurationHelper.months(Date.parse("2013-02-01"), Date.parse("2013-02-01"))
          end

          it 'calculates 0 months for given time span (same month)' do
            assert_equal 0, DurationHelper.months(Date.parse("2013-01-01"), Date.parse("2013-01-31"))
          end

          it 'calculates 1 month for given time span (1 month)' do
            assert_equal 1, DurationHelper.months(Date.parse("2013-03-01"), Date.parse("2013-04-01"))
          end

          it 'calculates 1 month for given time span (30 days)' do
            assert_equal 1, DurationHelper.months(Date.parse("2013-06-02"), Date.parse("2013-07-02"))
          end

          # Should be equal in duration compared to 'calculates 1 month for given time span (30 days)'
          it 'calculates 1 month for given time span (1 month)' do
            assert_equal 1, DurationHelper.months(Date.parse("2013-06-01"), Date.parse("2013-07-01"))
          end

          it 'calculates 2 months for given time span (2 months and something)' do
            assert_equal 2, DurationHelper.months(Date.parse("2013-03-20"), Date.parse("2013-06-19"))
          end

        end

      end
    end
  end
end