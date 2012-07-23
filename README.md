# Cube Evaluator [![Build Status](https://secure.travis-ci.org/matteodepalo/cube-evaluator.png)](http://travis-ci.org/matteodepalo/cube-evaluator)

Obtain data from cube evaluators in a nice format

## Installation

Add this to your Gemfile

```ruby
gem 'cube-evaluator'
```

and then run

    $ bundle

## Usage

Configure the cube evaluator client

```ruby
# use default hostname and port of localhost:1081
$cube_evaluator = Cube::Evaluator.new

# use custom hostname and port
$cube_evaluator = Cube::Evaluator.new 'cube.example.com', 2280
```

Ask for some metrics

```ruby
$cube_evaluator.metric(
  :expression => 'sum(request)',
  :start => Time.now - 2592000,
  :stop => Time.now,
  :limit => 10,
  :step => '1minute'
)
```

The result will be a json encoded Hash with an array of 'times' and the corresponding 'values' like

```ruby
{ 
  "times" => [
    "2012-07-16T11:40:00.000Z",
    "2012-07-16T11:41:00.000Z",
    "2012-07-16T11:42:00.000Z",
    "2012-07-16T11:43:00.000Z",
    "2012-07-16T11:44:00.000Z",
    "2012-07-16T11:45:00.000Z",
    "2012-07-16T11:46:00.000Z"
  ],
  "values" => [1, 2, 3, 4, 5, 6, 7]}
}
```

The supported steps are:

* 10seconds
* 1minute
* 5minutes
* 1hour
* 1day

For a complete guide on how to use the cube evaluator take a loot at:

https://github.com/square/cube/wiki/Evaluator

# TODO

* Add support for evaluator events and types