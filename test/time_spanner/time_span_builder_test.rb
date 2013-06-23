require 'test_helper'
require 'date'
require 'timecop'

module TimeSpanner
  class TimeSpanBuilderTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'should validate time units' do
      assert_raises InvalidUnitError do
        TimeSpanBuilder.new(@now, @now, [:days, :something])
      end
    end

    it 'should use default units when if no units are given (no parameter given)' do
      time_span_builder = TimeSpanBuilder.new(@now, @now)

      assert_equal TimeSpanBuilder::DEFAULT_UNITS, time_span_builder.units
    end

    it 'should use default units when if no units are given (nil given)' do
      time_span_builder = TimeSpanBuilder.new(@now, @now, nil)

      assert_equal TimeSpanBuilder::DEFAULT_UNITS, time_span_builder.units
    end

    it 'should use default units when if no units are given (empty Array given)' do
      time_span_builder = TimeSpanBuilder.new(@now, @now, [])

      assert_equal TimeSpanBuilder::DEFAULT_UNITS, time_span_builder.units
    end

    it 'should calculate no time units on zero duration' do
      starting_time = Time.at(DateTime.parse('2013-06-17 12:34:56').to_time, 0.0)
      target_time   = Time.at(DateTime.parse('2013-06-17 12:34:56').to_time, 0.0)
      time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

      assert_all_zero_except(time_span_builder, nil)
    end

    it 'should switch time span when target time is smaller than start time' do
      starting_time = DateTime.parse('2013-06-17 12:34:56')
      target_time   = DateTime.parse('2013-04-17 12:34:56')
      time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

      assert_equal target_time, time_span_builder.start_time
      assert_equal starting_time, time_span_builder.target_time
    end

    it 'should minusify time units when target time is smaller than start time' do
      starting_time = Time.at(DateTime.parse('5447-12-12 23:11:12').to_time, 3153476.737)
      target_time   = Time.at(DateTime.parse('2013-06-17 12:34:56').to_time, 2216234.383)
      time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

      expected = {millenniums: -3, centuries: -4, decades: -3, years: -4, months: -5, weeks: -3, days: -4, hours: -10, minutes: -36, seconds: -16, millis: -937, micros: -242, nanos: -354}
      assert_equal expected.sort, time_span_builder.time_span.sort
    end

    describe 'output all time units' do

      it 'should output days (in the future)' do
        starting_time = Date.parse('2013-06-17')
        target_time   = Date.parse('2013-06-20')
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        expected = {millenniums: 0, centuries: 0, decades: 0, years: 0, months: 0, weeks: 0, days: 3, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
        assert_equal expected.sort, time_span_builder.time_span.sort
      end

      it 'should output days and weeks (in the future)' do
        starting_time = Date.parse('2013-06-10')
        target_time   = Date.parse('2013-06-20')
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        expected = {millenniums: 0, centuries: 0, decades: 0, years: 0, months: 0, weeks: 1, days: 3, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
        assert_equal expected.sort, time_span_builder.time_span.sort
      end

      it 'should output days/weeks/months (in the future)' do
        starting_time = Date.parse('2013-06-10')
        target_time   = Date.parse('2013-08-20')
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        expected = {millenniums: 0, centuries: 0, decades: 0, years: 0, months: 2, weeks: 1, days: 3, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
        assert_equal expected.sort, time_span_builder.time_span.sort
      end

      it 'should output all time units (in the future)' do
        starting_time = Time.at(DateTime.parse('2013-06-17 12:34:56').to_time, 2216234.383)
        target_time   = Time.at(DateTime.parse('5447-12-12 23:11:12').to_time, 3153476.737)
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        expected = {millenniums: 3, centuries: 4, decades: 3, years: 4, months: 5, weeks: 3, days: 4, hours: 10, minutes: 36, seconds: 16, millis: 937, micros: 242, nanos: 354}

        assert_equal expected.sort, time_span_builder.time_span.sort
      end

    end

    describe 'output only 1 unit' do

      it 'should output only nanos' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 0.235)
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time, [:nanos])

        expected = {nanos: 235}
        assert_equal expected.sort, time_span_builder.time_span.sort
      end

    end

    describe 'output multiple units' do

      it 'should output only nanos' do
        starting_time = DateTime.parse('2013-06-10 00:20:00')
        target_time   = DateTime.parse('2013-07-13 02:20:00')
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time, [:days, :hours, :months])

        expected = {hours: 2, days: 3, months: 1}
        assert_equal expected.sort, time_span_builder.time_span.sort
      end

    end

    describe 'unit switches' do

      it 'switches everything' do
        starting_time = DateTime.parse('2000-01-01 00:00:00').to_time
        target_time   = DateTime.parse('3000-01-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:millenniums]
        assert_all_zero_except(time_span_builder, :millenniums)

        Timecop.travel(Time.at(starting_time.to_f, 0.001)) do
          starting_time = Time.at(starting_time.to_f, 0.001)
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:millenniums]
          assert_equal 9, time_span_builder.time_span[:centuries]
          assert_equal 9, time_span_builder.time_span[:decades]
          assert_equal 9, time_span_builder.time_span[:years]
          assert_equal 11, time_span_builder.time_span[:months]
          assert_equal 4, time_span_builder.time_span[:weeks]
          assert_equal 2, time_span_builder.time_span[:days]
          assert_equal 23, time_span_builder.time_span[:hours]
          assert_equal 59, time_span_builder.time_span[:minutes]
          assert_equal 59, time_span_builder.time_span[:seconds]
          assert_equal 999, time_span_builder.time_span[:millis]
          assert_equal 999, time_span_builder.time_span[:micros]
          assert_equal 999, time_span_builder.time_span[:nanos]
        end
      end

      it 'switches from millenniums to centuries' do
        starting_time = DateTime.parse('2000-01-01 00:00:00').to_time
        target_time   = DateTime.parse('3000-01-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:millenniums]
        assert_equal 0, time_span_builder.time_span[:centuries]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:millenniums]
          assert_equal 9, time_span_builder.time_span[:centuries]
        end
      end

      it 'switches from centuries to decades' do
        starting_time = DateTime.parse('1900-01-01 00:00:00').to_time
        target_time   = DateTime.parse('2000-01-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:centuries]
        assert_equal 0, time_span_builder.time_span[:decades]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:centuries]
          assert_equal 9, time_span_builder.time_span[:decades]
        end
      end

      it 'switches from decades to years' do
        starting_time = DateTime.parse('1910-01-01 00:00:00').to_time
        target_time   = DateTime.parse('1920-01-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:decades]
        assert_equal 0, time_span_builder.time_span[:years]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:decades]
          assert_equal 9, time_span_builder.time_span[:years]
        end
      end

      it 'switches from years to months' do
        starting_time = DateTime.parse('1910-01-01 00:00:00').to_time
        target_time   = DateTime.parse('1911-01-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:years]
        assert_equal 0, time_span_builder.time_span[:months]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:years]
          assert_equal 11, time_span_builder.time_span[:months]
        end
      end

      it 'switches from months to weeks' do
        starting_time = DateTime.parse('2013-01-01 00:00:00').to_time
        target_time   = DateTime.parse('2013-02-01 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:months]
        assert_equal 0, time_span_builder.time_span[:weeks]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:months]
          assert_equal 4, time_span_builder.time_span[:weeks]
        end
      end

      it 'switches from weeks to days' do
        starting_time = DateTime.parse('2013-01-01 00:00:00').to_time
        target_time   = DateTime.parse('2013-01-08 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:weeks]
        assert_equal 0, time_span_builder.time_span[:days]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:weeks]
          assert_equal 6, time_span_builder.time_span[:days]
        end
      end

      it 'switches from days to hours' do
        starting_time = DateTime.parse('2013-01-01 00:00:00').to_time
        target_time   = DateTime.parse('2013-01-02 00:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:days]
        assert_equal 0, time_span_builder.time_span[:hours]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:days]
          assert_equal 23, time_span_builder.time_span[:hours]
        end
      end

      it 'switches from hours to minutes' do
        starting_time = DateTime.parse('2013-01-01 22:00:00').to_time
        target_time   = DateTime.parse('2013-01-01 23:00:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:hours]
        assert_equal 0, time_span_builder.time_span[:minutes]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:hours]
          assert_equal 59, time_span_builder.time_span[:minutes]
        end
      end

      it 'switches from minutes to seconds' do
        starting_time = DateTime.parse('2013-01-01 22:01:00').to_time
        target_time   = DateTime.parse('2013-01-01 22:02:00').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:minutes]
        assert_equal 0, time_span_builder.time_span[:seconds]

        Timecop.travel(Time.at(starting_time.to_f, 100000.0)) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:minutes]
          assert_equal 59, time_span_builder.time_span[:seconds]
        end
      end

      it 'switches from seconds to millis' do
        starting_time = DateTime.parse('2013-01-01 22:01:00').to_time
        target_time   = DateTime.parse('2013-01-01 22:01:01').to_time
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:seconds]
        assert_equal 0, time_span_builder.time_span[:millis]

        Timecop.travel(Time.at(starting_time.to_f, 100.0)) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:seconds]
          assert_equal 999, time_span_builder.time_span[:millis] #TODO: sometimes fails with inaccurate nanos
        end
      end

      it 'switches from millis to micros' do
        starting_time = Time.at(DateTime.parse('2013-01-01 22:01:00').to_time.to_f)
        target_time   = Time.at(DateTime.parse('2013-01-01 22:01:00').to_time.to_f, 1000.0)
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:millis]
        assert_equal 0, time_span_builder.time_span[:micros]

        Timecop.travel(Time.at(starting_time.to_f, 0.1)) do
          starting_time = Time.at(starting_time.to_f, 0.1)
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:millis]
          assert_equal 999, time_span_builder.time_span[:micros]
        end
      end

      it 'switches from micro- to nanoseconds' do
        starting_time = Time.at(DateTime.parse('2013-01-01 22:01:00').to_time.to_f)
        target_time   = Time.at(DateTime.parse('2013-01-01 22:01:00').to_time.to_f, 1.0)
        time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span_builder.time_span[:micros]
        assert_equal 0, time_span_builder.time_span[:nanos]

        Timecop.travel(Time.at(starting_time.to_f, 0.001)) do
          starting_time = Time.at(starting_time.to_f, 0.001)
          target_time   = target_time
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span_builder.time_span[:micros]
          assert_equal 999, time_span_builder.time_span[:nanos]
        end
      end

    end

    describe 'edge cases' do

      describe 'unix epoch' do

        it 'should calculate dates before 1970' do
          starting_time = DateTime.parse('1960-01-01 00:00:00')
          target_time   = DateTime.parse('2010-01-01 00:00:00')
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          refute target_time == starting_time

          expected = {millenniums: 0, centuries: 0, decades: 5, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span_builder.time_span.sort
        end

        it 'should calculate dates after 2039' do
          starting_time = DateTime.parse('1960-01-01 00:00:00')
          target_time   = DateTime.parse('2050-01-01 00:00:00')
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          refute target_time == starting_time

          expected = {millenniums: 0, centuries: 0, decades: 9, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span_builder.time_span.sort
        end

      end

      describe 'time zone switches' do

        it 'switches to summer time' do
          starting_time = DateTime.parse('2013-03-31 01:59:00 CEST')
          target_time   = DateTime.parse('2013-03-31 02:01:00 CEST')
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 2, time_span_builder.time_span[:minutes]
          assert_all_zero_except(time_span_builder, :minutes)
        end

        it 'switches to winter time' do
          starting_time = DateTime.parse('2013-10-31 02:59:00 CEST')
          target_time   = DateTime.parse('2013-10-31 03:01:00 CEST')
          time_span_builder = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 2, time_span_builder.time_span[:minutes]
          assert_all_zero_except(time_span_builder, :minutes)
        end

      end

    end


    private

    def assert_all_zero_except(time_span_builder, *time_units)
      units = [:millenniums, :decades, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos] - time_units
      not_zero = []
      units.each do |time_unit|
        not_zero << time_unit if time_span_builder.duration.instance_variable_get(:"@#{time_unit}") != 0
      end

      assert not_zero.empty?, "All units except #{time_units} should be 0: #{time_span_builder.duration}"
    end

  end
end