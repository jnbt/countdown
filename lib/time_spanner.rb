require 'time_spanner/time_units'
require 'time_spanner/time_unit_collector'
require 'time_spanner/duration_chain'
require 'time_spanner/time_span_builder'

module TimeSpanner

  def self.new(from, to, options={})
    TimeSpanBuilder.new(from, to, options[:units])
  end

end