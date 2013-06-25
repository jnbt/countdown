require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class MonthTest < TestCase
      include TimeHelpers

      it 'initializes' do
        month = Month.new

        assert month.kind_of?(TimeUnit)
        assert_equal 5, month.position
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2013-06-01 00:00:00')
        month         = Month.new

        month.calculate(starting_time, target_time)

        assert_equal 2, month.amount
        assert_equal 0, month.rest
      end

      it 'calculates with rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_months = DateTime.parse('2013-06-01 00:00:00')
        target_time   = Time.at(target_months.to_time.to_r, 0.999)
        month         = Month.new

        month.calculate(starting_time, target_time)

        assert_equal 2, month.amount
        assert_equal 999, month.rest
      end

    end
  end
end