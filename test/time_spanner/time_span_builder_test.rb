require 'test_helper'
require 'date'
require 'timecop'

module TimeSpanner
  class TimeSpanBuilderTest < TestCase

    before do
      @now = DateTime.now
    end

    it 'should calculate no time units on zero duration' do
      starting_time = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 0.0)
      target_time   = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 0.0)
      time_span     = TimeSpanBuilder.new(starting_time, target_time)

      assert_all_zero_except(time_span, nil)
    end

    it 'should calculate all time units (in the future)' do
      starting_time = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 2216234.383)
      target_time   = Time.at(DateTime.parse("5447-12-12 23:11:12").to_time, 3153476.737)
      time_span     = TimeSpanBuilder.new(starting_time, target_time)

      expected = {millenniums: 3, centuries: 4, decades: 3, years: 4, months: 5, weeks: 1, days: 5, hours: 10, minutes: 36, seconds: 16, millis: 937, micros: 242, nanos: 354}
      assert_equal expected.sort, time_span.duration.sort
    end

    it 'should calculate all time units backwards when target_time is before starting_time' do
      starting_time = Time.at(DateTime.parse("5447-12-12 23:11:12").to_time, 3153476.737)
      target_time   = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 2216234.383)
      time_span     = TimeSpanBuilder.new(starting_time, target_time)

      expected = {millenniums: -3, centuries: -4, decades: -3, years: -4, months: -5, weeks: -1, days: -5, hours: -10, minutes: -36, seconds: -16, millis: -937, micros: -242, nanos: -354}
      assert_equal expected.sort, time_span.duration.sort
    end

    describe 'unit switches' do

      it 'switches everything' do
        starting_time = DateTime.parse("2000-01-01 00:00:00").to_time
        target_time   = DateTime.parse("3000-01-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:millenniums]
        assert_all_zero_except(time_span, :millenniums)

        Timecop.travel(Time.at(starting_time.to_f, 0.001)) do
          starting_time = Time.at(starting_time.to_f, 0.001)
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:millenniums]
          assert_equal 9, time_span.duration[:centuries]
          assert_equal 9, time_span.duration[:decades]
          assert_equal 9, time_span.duration[:years]
          assert_equal 11, time_span.duration[:months]
          assert_equal 0, time_span.duration[:weeks]
          assert_equal 0, time_span.duration[:days]
          assert_equal 23, time_span.duration[:hours]
          assert_equal 59, time_span.duration[:minutes]
          assert_equal 59, time_span.duration[:seconds]
          assert_equal 999, time_span.duration[:millis]
          assert_equal 999, time_span.duration[:micros]
          assert_equal 999, time_span.duration[:nanos]
        end
      end

      it 'switches from millenniums to centuries' do
        starting_time = DateTime.parse("2000-01-01 00:00:00").to_time
        target_time   = DateTime.parse("3000-01-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:millenniums]
        assert_equal 0, time_span.duration[:centuries]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:millenniums]
          assert_equal 9, time_span.duration[:centuries]
        end
      end

      it 'switches from centuries to decades' do
        starting_time = DateTime.parse("1900-01-01 00:00:00").to_time
        target_time   = DateTime.parse("2000-01-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:centuries]
        assert_equal 0, time_span.duration[:decades]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:centuries]
          assert_equal 9, time_span.duration[:decades]
        end
      end

      it 'switches from decades to years' do
        starting_time = DateTime.parse("1910-01-01 00:00:00").to_time
        target_time   = DateTime.parse("1920-01-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:decades]
        assert_equal 0, time_span.duration[:years]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:decades]
          assert_equal 9, time_span.duration[:years]
        end
      end

      it 'switches from years to months' do
        starting_time = DateTime.parse("1910-01-01 00:00:00").to_time
        target_time   = DateTime.parse("1911-01-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:years]
        assert_equal 0, time_span.duration[:months]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:years]
          assert_equal 11, time_span.duration[:months]
        end
      end

      it 'switches from months to weeks' do
        starting_time = DateTime.parse("2013-01-01 00:00:00").to_time
        target_time   = DateTime.parse("2013-02-01 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:months]
        assert_equal 0, time_span.duration[:weeks]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:months]
          assert_equal 4, time_span.duration[:weeks]
        end
      end

      it 'switches from weeks to days' do
        starting_time = DateTime.parse("2013-01-01 00:00:00").to_time
        target_time   = DateTime.parse("2013-01-08 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:weeks]
        assert_equal 0, time_span.duration[:days]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:weeks]
          assert_equal 6, time_span.duration[:days]
        end
      end

      it 'switches from days to hours' do
        starting_time = DateTime.parse("2013-01-01 00:00:00").to_time
        target_time   = DateTime.parse("2013-01-02 00:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:days]
        assert_equal 0, time_span.duration[:hours]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:days]
          assert_equal 23, time_span.duration[:hours]
        end
      end

      it 'switches from hours to minutes' do
        starting_time = DateTime.parse("2013-01-01 22:00:00").to_time
        target_time   = DateTime.parse("2013-01-01 23:00:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:hours]
        assert_equal 0, time_span.duration[:minutes]


        Timecop.travel(starting_time+1) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:hours]
          assert_equal 59, time_span.duration[:minutes]
        end
      end

      it 'switches from minutes to seconds' do
        starting_time = DateTime.parse("2013-01-01 22:01:00").to_time
        target_time   = DateTime.parse("2013-01-01 22:02:00").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:minutes]
        assert_equal 0, time_span.duration[:seconds]

        Timecop.travel(Time.at(starting_time.to_f, 100000.0)) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:minutes]
          assert_equal 59, time_span.duration[:seconds]
        end
      end

      it 'switches from seconds to millis' do
        starting_time = DateTime.parse("2013-01-01 22:01:00").to_time
        target_time   = DateTime.parse("2013-01-01 22:01:01").to_time
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:seconds]
        assert_equal 0, time_span.duration[:millis]

        Timecop.travel(Time.at(starting_time.to_f, 100.0)) do
          starting_time = Time.at Time.now.to_time.to_f
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:seconds]
          assert_equal 999, time_span.duration[:millis] #TODO: sometimes fails with inaccurate nanos (999-997)
        end
      end

      it 'switches from millis to micros' do
        starting_time = Time.at(DateTime.parse("2013-01-01 22:01:00").to_time.to_f)
        target_time   = Time.at(DateTime.parse("2013-01-01 22:01:00").to_time.to_f, 1000.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:millis]
        assert_equal 0, time_span.duration[:micros]

        Timecop.travel(Time.at(starting_time.to_f, 0.1)) do
          starting_time = Time.at(starting_time.to_f, 0.1)
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:millis]
          assert_equal 999, time_span.duration[:micros]
        end
      end

      it 'switches from micro- to nanoseconds' do
        starting_time = Time.at(DateTime.parse("2013-01-01 22:01:00").to_time.to_f)
        target_time   = Time.at(DateTime.parse("2013-01-01 22:01:00").to_time.to_f, 1.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:micros]
        assert_equal 0, time_span.duration[:nanos]

        Timecop.travel(Time.at(starting_time.to_f, 0.001)) do
          starting_time = Time.at(starting_time.to_f, 0.001)
          target_time   = target_time
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 0, time_span.duration[:micros]
          assert_equal 999, time_span.duration[:nanos]
        end
      end

    end

    describe 'edge cases' do

      describe 'unix epoch' do

        it 'should calculate dates before 1970' do
          starting_time = DateTime.parse("1960-01-01 00:00:00")
          target_time   = DateTime.parse("2010-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          refute target_time == starting_time

          expected = {millenniums: 0, centuries: 0, decades: 5, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'should calculate dates after 2039' do
          starting_time = DateTime.parse("1960-01-01 00:00:00")
          target_time   = DateTime.parse("2050-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          refute target_time == starting_time

          expected = {millenniums: 0, centuries: 0, decades: 9, years: 0, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

      end

      describe 'time zone switches' do

        it 'switches to summer time' do
          starting_time = DateTime.parse("2013-03-31 01:59:00 CEST")
          target_time   = DateTime.parse("2013-03-31 02:01:00 CEST")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 2, time_span.duration[:minutes]
          assert_all_zero_except(time_span, :minutes)
        end

        it 'switches to winter time' do
          starting_time = DateTime.parse("2013-10-31 02:59:00 CEST")
          target_time   = DateTime.parse("2013-10-31 03:01:00 CEST")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          assert_equal 2, time_span.duration[:minutes]
          assert_all_zero_except(time_span, :minutes)
        end

      end

    end

    describe 'millenniums' do

      it 'should calculate 1 millennium' do
        starting_time = DateTime.parse("1000-06-02 00:00:00")
        target_time   = DateTime.parse("2000-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:millenniums]
        assert_all_zero_except(time_span, :millenniums)
      end

      it 'should calculate 2 millenniums' do
        starting_time = DateTime.parse("0000-06-02 00:00:00")
        target_time   = DateTime.parse("2000-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:millenniums]
        assert_all_zero_except(time_span, :millenniums)
      end

    end

    describe 'centuries' do

      it 'should calculate 1 century' do
        starting_time = DateTime.parse("2000-06-02 00:00:00")
        target_time   = DateTime.parse("2100-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:centuries]
        assert_all_zero_except(time_span, :centuries)
      end

      it 'should calculate 2 centuries' do
        starting_time = DateTime.parse("1900-06-02 00:00:00")
        target_time   = DateTime.parse("2100-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:centuries]
        assert_all_zero_except(time_span, :centuries)
      end

    end

    describe 'decades' do

      it 'should calculate 1 decade' do
        starting_time = DateTime.parse("2010-06-02 00:00:00")
        target_time   = DateTime.parse("2020-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:decades]
        assert_all_zero_except(time_span, :decades)
      end

      it 'should calculate 2 decades' do
        starting_time = DateTime.parse("2010-06-02 00:00:00")
        target_time   = DateTime.parse("2030-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:decades]
        assert_all_zero_except(time_span, :decades)
      end

    end

    describe 'years' do

      it 'should calculate 1 year' do
        starting_time = DateTime.parse("2013-06-02 00:00:00")
        target_time   = DateTime.parse("2014-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:years]
        assert_all_zero_except(time_span, :years)
      end

      it 'should calculate 2 years' do
        starting_time = DateTime.parse("2013-06-02 00:00:00")
        target_time   = DateTime.parse("2015-06-02 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:years]
        assert_all_zero_except(time_span, :years)
      end

      #TODO: remove when DurationHelper.duration[:years]() does the calculation
      describe 'leaps' do

        it 'has no leap year' do
          starting_time = DateTime.parse("2013-01-01 00:00:00")
          target_time   = DateTime.parse("2014-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'should be 1 year on exact leap date (start is leap)' do
          starting_time = DateTime.parse("2012-02-29 00:00:00") # leap year
          target_time   = DateTime.parse("2013-02-28 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'should be 1 year on exact leap date (target is leap)' do
          starting_time = DateTime.parse("2011-02-28 00:00:00")
          target_time   = DateTime.parse("2012-02-29 00:00:00") # leap year
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'has 1 leap year' do
          starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
          target_time   = DateTime.parse("2013-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 1, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'has 1 leap year within 3 years' do
          starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
          target_time   = DateTime.parse("2015-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 3, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'has 2 leap years within 4 years' do
          starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
          target_time   = DateTime.parse("2016-01-01 00:00:00") # leap year
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 4, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

        it 'has 3 leap years within 8 years' do
          starting_time = DateTime.parse("2012-01-01 00:00:00") # leap year
          target_time   = DateTime.parse("2020-01-01 00:00:00")
          time_span     = TimeSpanBuilder.new(starting_time, target_time)

          expected = {millenniums: 0, centuries: 0, decades: 0, years: 8, months: 0, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, millis: 0, micros: 0, nanos: 0}
          assert_equal expected.sort, time_span.duration.sort
        end

      end

    end

    describe 'months' do

      it 'should calculate 1 month' do
        starting_time = DateTime.parse("2012-06-01 00:00:00")
        target_time   = DateTime.parse("2012-07-01 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_all_zero_except(time_span, :months)
        assert_equal 1, time_span.duration[:months]
      end

      it 'should calculate 2 months' do
        starting_time = DateTime.parse("2012-06-01 00:00:00")
        target_time   = DateTime.parse("2012-08-01 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_all_zero_except(time_span, :months)
        assert_equal 2, time_span.duration[:months]
      end

    end

    describe 'weeks' do

      it 'should calculate 1 week' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-09 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:weeks]
        assert_all_zero_except(time_span, :weeks)
      end

      it 'should calculate 2 weeks' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-16 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:weeks]
        assert_all_zero_except(time_span, :weeks)
      end

    end

    describe 'days' do

      it 'should calculate 1 day' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-03 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:days]
        assert_all_zero_except(time_span, :days)
      end

      it 'should calculate 2 days' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-04 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:days]
        assert_all_zero_except(time_span, :days)
      end

      it 'should calculate 0 days on whole year (not leap)' do
        starting_time = DateTime.parse("2013-06-01 00:00:00")
        target_time   = DateTime.parse("2014-06-01 00:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 0, time_span.duration[:days]
        assert_equal 1, time_span.duration[:years]
        assert_all_zero_except(time_span, :years)
      end

    end

    describe 'hours' do

      it 'should calculate 1 hour' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 01:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:hours]
        assert_all_zero_except(time_span, :hours)
      end

      it 'should calculate 2 hours' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 02:00:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:hours]
        assert_all_zero_except(time_span, :hours)
      end

    end

    describe 'minutes' do

      it 'should calculate 1 minute' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:01:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:minutes]
        assert_all_zero_except(time_span, :minutes)
      end

      it 'should calculate 2 minutes' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:02:00")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:minutes]
        assert_all_zero_except(time_span, :minutes)
      end

    end

    describe 'seconds' do

      it 'should calculate 1 seconds' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:00:01")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 1, time_span.duration[:seconds]
        assert_all_zero_except(time_span, :seconds)
      end

      it 'should calculate 2 seconds' do
        starting_time = DateTime.parse("2012-06-02 00:00:00")
        target_time   = DateTime.parse("2012-06-02 00:00:02")
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:seconds]
        assert_all_zero_except(time_span, :seconds)
      end

    end

    describe 'milliseconds' do

      it 'should calculate 1 millisecond' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 1000.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 1, time_span.duration[:millis]
        assert_all_zero_except(time_span, :millis)
      end

      it 'should calculate 2 milliseconds' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 2000.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 2, time_span.duration[:millis]
        assert_all_zero_except(time_span, :millis)
      end

      it 'should calculate 4 milliseconds' do
        starting_time = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 101000.0)
        target_time   = Time.at(DateTime.parse("2013-06-17 12:34:56").to_time, 618000.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        assert_equal 517, time_span.duration[:millis]
        assert_all_zero_except(time_span, :millis)
      end

    end

    describe 'microseconds' do

      it 'should calculate 1 microsecond' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 1.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 1, time_span.duration[:micros]
        assert_all_zero_except(time_span, :micros)
      end

      it 'should calculate 235 microseconds' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 235.0)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 235, time_span.duration[:micros]
        assert_all_zero_except(time_span, :micros)
      end

    end

    describe 'nanoseconds' do

      it 'should calculate 1 nanosecond' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 0.001)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 1, time_span.duration[:nanos]
        assert_all_zero_except(time_span, :nanos)
      end

      it 'should calculate 235 nanoseconds' do
        starting_time = Time.at @now.to_time.to_f
        target_time   = Time.at(starting_time.to_f, 0.235)
        time_span     = TimeSpanBuilder.new(starting_time, target_time)

        refute target_time == starting_time

        assert_equal 235, time_span.duration[:nanos]
        assert_all_zero_except(time_span, :nanos)
      end

    end

    private

    def assert_all_zero_except(time_spanner, *time_units)
      units = [:millenniums, :decades, :decades, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis, :micros, :nanos] - time_units
      not_zero = []
      units.each do |time_unit|
        not_zero << time_unit if time_spanner.time_span.instance_variable_get(:"@#{time_unit}") != 0
      end

      assert not_zero.empty?, "All units except #{time_units} should be 0: #{time_spanner.duration}"
    end

  end
end