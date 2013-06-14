countdown
=========

Add a visible countdown to your views. Which counts down by supplied steps via JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'countdown'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install countdown

## Example


```ruby
 <%= countdown Time.now + 28.hours, step: :seconds, seperators: { day: "days", hour: ":", min: ":", sec: nil }, leading_zeroes: true %>
```
Separators are optional and default to { day: "s", hour: "h", min: "m", sec: "s" }

Possible values for steps are:
<pre>:seconds, :minutes, :hours, :days</pre>


Results in a countdowns like this:

<pre>
1 day 03:59:59
</pre>

The generated html looks like this:

```ruby
<div class="countdown">
  <span class="days">1</span>
  <span class="day-separator"> day </span>
  <span class="hours">03</span>
  <span class="hour-separator">:</span>
  <span class="minutes">59</span>
  <span class="minute-separator">:</span>
  <span class="seconds">59</span>
</div>
```

## TODO:

- Everything

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
