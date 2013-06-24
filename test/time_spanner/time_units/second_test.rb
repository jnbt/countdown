require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits
    include TimeHelpers

    class SecondTest < TestCase

      before do
        @second = Second.new
      end

      it 'initializes' do
        assert @second.kind_of?(TimeUnit)
        assert_equal 10, @second.position
        assert_equal 0, @second.amount
        assert_equal 0, @second.rest
      end

      it 'calculates' do
        starting_time = DateTime.parse('2012-12-14 00:00:00')
        target_time   = DateTime.parse('2012-12-14 00:00:02')

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds

        @second.calculate(nanoseconds)

        assert_equal 2, @second.amount
        assert_equal 0, @second.rest
      end

      it 'calculates with rest' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 2187223.999)

        nanoseconds = TimeHelpers::TimeSpan.new(starting_time, target_time).total_nanoseconds
        @second.calculate(nanoseconds)

        assert_equal 2, @second.amount
        assert_equal 187223999, @second.rest
      end

    end
  end
end