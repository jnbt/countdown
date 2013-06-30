require 'test_helper'

module TimeSpanner
  module TimeUnits

    class SecondTest < TestCase

      it 'initializes' do
        second = Second.new

        assert second.kind_of?(TimeUnit)
        assert_equal 10, second.position
        assert_equal :seconds, second.plural_name
      end

      it 'calculates' do
        from     = Time.parse('2012-12-14 00:00:00')
        to       = Time.parse('2012-12-14 00:00:02')
        duration = Nanosecond.duration from, to
        second   = Second.new

        second.calculate duration

        assert_equal 2, second.amount
        assert_equal 0, second.rest
      end

      it 'calculates with rest' do
        from           = Time.now
        target_seconds = Time.at(from.to_r, 2000000.0)
        to             = Time.at(target_seconds.to_r, 0.999)
        duration       = Nanosecond.duration from, to
        second         = Second.new

        second.calculate duration

        assert_equal 2, second.amount
        assert_equal 999, second.rest
      end

    end
  end
end