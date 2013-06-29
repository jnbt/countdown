require 'test_helper'

module TimeSpanner
  module TimeUnits

    class NanosecondTest < TestCase

      it 'initializes' do
        nanosecond = Nanosecond.new

        assert nanosecond.kind_of?(TimeUnit)
        assert_equal 13, nanosecond.position
        assert_equal :nanoseconds, nanosecond.plural_name
      end

      it 'calculates' do
        starting_time = Time.at Time.now.to_f
        target_time   = Time.at(starting_time.to_f, 0.002)
        nanosecond    = Nanosecond.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        nanosecond.calculate(nanoseconds)

        assert_equal 2, nanosecond.amount
        assert_equal 0, nanosecond.rest
      end

      it 'calculate without rest' do
        starting_time = Time.at Time.now.to_r
        target_time   = Time.at(starting_time.to_r, 0.0024567465)
        nanosecond    = Nanosecond.new

        nanoseconds = Nanosecond.duration starting_time, target_time
        nanosecond.calculate(nanoseconds)

        assert_equal 2, nanosecond.amount
        assert_equal 0, nanosecond.rest
      end

      describe 'duration' do

        before do
          @now = DateTime.now
        end

        it 'should be Integer' do
          assert Nanosecond.duration(@now, @now+1).is_a?(Integer)
        end

        it 'calculates nanoseconds for 1 day in the future' do
          assert_equal 86400000000000, Nanosecond.duration(@now, @now+1)
        end

        it 'calculates nanoseconds for 1 day last week' do
          assert_equal 86400000000000, Nanosecond.duration(@now-7, @now-6)
        end

        it 'calculates nanoseconds for 1 day in the past' do
          assert_equal -86400000000000,  Nanosecond.duration(@now, @now-1)
        end

        it 'calculates nanoseconds for same timestamp' do
          assert_equal 0, Nanosecond.duration(@now, @now)
        end

      end

    end
  end
end