require 'test_helper'

module TimeSpanner
  module TimeUnits

    class DecadeTest < TestCase

      it 'initializes' do
        decade = Decade.new

        assert decade.kind_of?(CalendarUnit)
        assert_equal 3, decade.position
        assert_equal :decades, decade.plural_name
      end

      it 'calculates without rest' do
        from     = Time.parse('2023-04-01 00:00:00')
        to       = Time.parse('2043-04-01 00:00:00')
        duration = Nanosecond.duration from, to
        decade   = Decade.new

        decade.calculate duration, to

        assert_equal 2, decade.amount
        assert_equal 0, decade.rest
      end

      it 'calculates with rest (1 second in nanoseconds)' do
        from     = Time.parse('2013-01-01 00:00:00')
        to       = Time.parse('2033-01-01 00:00:01')
        duration = Nanosecond.duration from, to
        decade   = Decade.new

        decade.calculate duration, to

        assert_equal 2, decade.amount
        assert_equal 1000000000, decade.rest
      end

      it 'calculates correctly on exact leap day' do
        from     = Time.parse('2012-02-29 00:00:00') # leap year
        to       = Time.parse('2022-02-28 00:00:00')
        duration = Nanosecond.duration from, to
        decade   = Decade.new

        decade.calculate duration, to

        assert_equal 1, decade.amount
        assert_equal 0, decade.rest
      end

    end
  end
end