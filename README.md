# Cube Evaluator

# URL Formatter [![Build Status](https://secure.travis-ci.org/matteodepalo/cube-evaluator.png)](http://travis-ci.org/matteodepalo/cube-evaluator)

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

The result will be a json encoded Hash with an array of 'times' and the corresponding 'values'

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