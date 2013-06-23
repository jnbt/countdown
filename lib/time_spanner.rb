require 'time_spanner/time_span_builder'

module TimeSpanner

  def self.new(from, to, options={})
    TimeSpanBuilder.new(from, to, options[:units])
  end

end