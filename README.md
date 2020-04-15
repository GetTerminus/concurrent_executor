# concurrent_executor
Eat your enumerables in threads and fast!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'concurrent_executer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install concurrent_executer

## Usage
```ruby
require 'concurrent_executer'

some_enumerable = [1, 2, 3, 4]
ConcurrentExecutor.consume_enumerable(some_enumerable) do |num|
  # do something to each item
end
```

