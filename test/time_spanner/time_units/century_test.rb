require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class CenturyTest < TestCase
      include TimeHelpers

      it 'initializes' do
        century = Century.new

        assert century.kind_of?(TimeUnit)
        assert_equal 2, century.position
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2213-04-01 00:00:00')
        century       = Century.new

        century.calculate(starting_time, target_time)

        assert_equal 2, century.amount
        assert_equal 0, century.rest
      end

=begin
      it 'calculates with rest (1 decade in nanoseconds)' do
        starting_time = DateTime.parse('2013-01-01 00:00:00')
        target_time   = DateTime.parse('2223-01-01 00:00:00')
        century       = Century.new

        century.calculate(starting_time, target_time)

        assert_equal 2, century.amount
        assert_equal 315569520000000000, century.rest
      end
=end

    end
  end
end