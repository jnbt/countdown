require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/duration_helper'
require 'time_spanner/time_units'
require 'time_spanner/time_helpers/time_span'
require 'time_spanner/time_span_builder'

module TimeSpanner

  def self.new(from, to, options={})
    TimeSpanBuilder.new(from, to, options[:units])
  end

end