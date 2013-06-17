require 'date'

module Countdown
  class TimeSpan

    attr_reader :start_time, :target_time, :duration_in_ms, :years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis

    def initialize(start_time=DateTime.now, target_time)
      @start_time     = start_time
      @target_time    = target_time
      @duration_in_ms = duration_in_ms
      @years          = duration[:years]
      @months         = duration[:months]
      @weeks          = duration[:weeks]
      @days           = duration[:days]
      @hours          = duration[:hours]
      @minutes        = duration[:minutes]
      @seconds        = duration[:seconds]
      @millis         = duration[:millis]
    end

    def [](unit)
      send unit
    end

    def duration_in_ms
      ((target_time.to_time - DateTime.now.to_time).to_f.round*1000).to_i
    end

    private

    def duration
      @__duration ||= calculate_units
    end

    def calculate_units
      rest, millis  = duration_in_ms.divmod(1000)
      rest, seconds = rest.divmod(60)
      rest, minutes = rest.divmod(60)
      rest, hours   = rest.divmod(24)
      rest, days    = rest.divmod(30) # TODO: month can be 28,29,31 aswell
      years, months = rest.divmod(12)
      weeks, days   = days.divmod(7)

      {years: years, months: months, weeks: weeks, days: days, hours: hours, minutes: minutes, seconds: seconds, millis: millis}
    end

  end
end