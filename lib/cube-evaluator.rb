require "cube-evaluator/version"
require 'json'

module Cube
  class Evaluator
    def initialize(host = 'localhost', port = 1081)
      @url = "http://#{host}:#{port}/"
    end

    def url
      @url || ""
    end

    def metric(options = {})
      uri = URI(@url) + "1.0/metric/get"

      params = options.merge(options) do |k,v|
        if [DateTime, Date, Time].any?{ |klass| v.is_a?(klass) }
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

    private

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