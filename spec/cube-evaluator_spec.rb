require 'spec_helper'

describe Cube::Evaluator do
  before(:all) do
    @cube = Cube::Evaluator.new
  end

  describe "#initialize" do
    it "should set the url" do
      @cube = Cube::Evaluator.new "cube.example.org", 1185
      @cube.url.should == "http://cube.example.org:1185/"
    end

    it "should default the host and port to localhost:1081" do
      @cube.url.should == "http://localhost:1081/"
    end
  end

  describe "#metric" do
    before(:all) do
      @fake_response = [
        {"time" => "2012-07-16T11:40:00.000Z", "value" => 1},
        {"time" => "2012-07-16T11:41:00.000Z", "value" => 2},
        {"time" => "2012-07-16T11:42:00.000Z", "value" => 3},
        {"time" => "2012-07-16T11:43:00.000Z", "value" => 4},
        {"time" => "2012-07-16T11:44:00.000Z", "value" => 5},
        {"time" => "2012-07-16T11:45:00.000Z", "value" => 6},
        {"time" => "2012-07-16T11:46:00.000Z", "value" => 7}
      ]

      stub_request(:get, "http://localhost:1081/1.0/metric/get").
        with(
          :query => {
            'expression' => 'sum(cube_requests)',
            'start' => '2012-04-16T16:00:00Z',
            'stop' => '2012-04-16T17:00:00Z',
            'step' => '6e4',
            'limit' => '10'
          },
          :headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}
        ).
        to_return(:status => 200, :body => @fake_response.to_json, :headers => {})
    end

    it "should return the response with the times and values hash" do
      @metric = {
        :times => [],
        :values => []
      }

      @fake_response.each do |metric|
        @metric[:times] << Time.parse(metric['time'])
        @metric[:values] << metric['value']
      end

      @cube.metric(
        :expression => 'sum(cube_requests)',
        :start => Time.parse('2012-04-16T16:00Z'),
        :stop => Time.parse('2012-04-16T17:00Z'),
        :step => '1minute',
        :limit => '10'
      ).should == @metric
    end
  end

  describe "#to_step" do
    it "should return the supported step" do
      @cube.send(:to_step, "10seconds").should == '1e4'
      @cube.send(:to_step, "1minute").should == '6e4'
      @cube.send(:to_step, "5minutes").should == '3e5'
      @cube.send(:to_step, "1hour").should == '36e5'
      @cube.send(:to_step, "1day").should == '864e5'
    end
  end
end