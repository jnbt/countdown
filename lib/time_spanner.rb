require 'time_spanner/errors'
require 'time_spanner/time_units'
require 'time_spanner/time_unit_collector'
require 'time_spanner/duration_chain'
require 'time_spanner/time_span_builder'

module TimeSpanner
  include Errors

  def self.new(from, to, options={})
    raise InvalidClassError, "Must convert to Time object!" unless [from, to].all?{ |obj| obj.respond_to?(:to_time) && obj.to_time.is_a?(Time)}

    TimeSpanBuilder.new from.to_time, to.to_time, options[:units]
  end

end