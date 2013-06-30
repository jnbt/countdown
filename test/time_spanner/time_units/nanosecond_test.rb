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
        from       = Time.now
        to         = Time.at(from.to_r, 0.002)
        duration   = Nanosecond.duration from, to
        nanosecond = Nanosecond.new

        nanosecond.calculate duration

        assert_equal 2, nanosecond.amount
        assert_equal 0, nanosecond.rest
      end

      it 'calculate without rest' do
        from       = Time.now
        to         = Time.at(from.to_r, 0.0024567465)
        duration   = Nanosecond.duration from, to
        nanosecond = Nanosecond.new

        nanosecond.calculate duration

        assert_equal 2, nanosecond.amount
        assert_equal 0, nanosecond.rest
      end

      describe 'duration' do

        before do
          @now = Time.now
        end

        it 'should be Integer' do
          assert Nanosecond.duration(@now, @now+86400).is_a?(Integer)
        end

        it 'calculates nanoseconds for 1 day in the future' do
          assert_equal 86400000000000, Nanosecond.duration(@now, @now+86400)
        end

        it 'calculates nanoseconds for 1 day last week' do
          assert_equal 86400000000000, Nanosecond.duration(@now-604800, @now-518400)
        end

        it 'calculates nanoseconds for 1 day in the past' do
          assert_equal -86400000000000,  Nanosecond.duration(@now, @now-86400)
        end

        it 'calculates nanoseconds for same timestamp' do
          assert_equal 0, Nanosecond.duration(@now, @now)
        end

      end

    end
  end
end