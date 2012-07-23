require "cube-evaluator/version"

module Cube
  class Evaluator
    def initialize(url = 'localhost', port = 1081)
      @url = "http://#{url}:#{port}/1.0/metric/get"
    end

    def metric(options = {})
      uri = URI(@url)

      params = options.merge(options) do |k,v|
        if v.is_a?(DateTime) || v.is_a?(Date) || v.is_a?(Time)
          v.to_time.utc.iso8601
        elsif k == :step
          to_step(v)
        else
          v
        end
      end

      uri.query = URI.encode_www_form(params)
      res = Net::HTTP.get_response(uri)
      json_res = JSON.parse(res.body)

      json_res = json_res.map do |metric|
        metric.merge(metric) { |k, v| k == 'time' ? Time.parse(v) : v  }  
      end

      result = { :times => [], :values => [] }

      json_res.each do |metric|
        metric.each do |k,v|
          if k == 'time'
            result[:times] << v
          elsif k == 'value'
            result[:values] << v
          end
        end
      end

      result
    end

    def to_step(step)
      case step
      when '10seconds'
        '1e4'
      when '1minute'
        '6e4'
      when '5minutes'
        '3e5'
      when '1hour'
        '36e5'
      when '1day'
        '864e5'
      end
    end
  end
end