countdown
=========

Adds a visible countdown to your views, which counts down by supplied steps via JavaScript.

## Installation

Add this line to your application's Gemfile:

    gem 'countdown'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install countdown

## Usage

```ruby
 <%= countdown Time.now + 28.hours %>
```
results in a countdown like this:

<pre>
1d03h59m59s
</pre>

It is updated every second and the generated html looks like this:

```ruby
<div class="countdown">
  <span class="days day_001">1</span>
  <span class="day-separator">d</span>
  <span class="hours hour_03">03</span>
  <span class="hour-separator">h</span>
  <span class="minutes minute_59">59</span>
  <span class="minute-separator">m</span>
  <span class="seconds second_59">59</span>
  <span class="minute-separator">s</span>
</div>
```

### Options

####:step

Define how often the counter should be updated.
Possible steps are:
<pre>:millis, :seconds, :minutes, :hours, :days</pre>

Default is <pre>:seconds</pre>

####:units

Define which time units should be displayed and how they should be ordered.

Available keys are:
<pre>:years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis</pre>

Default is
```ruby
[:days, :hours, :minutes, :seconds]
```
####:separators

Define how different time units are separated from each other.

Available keys are:
<pre>:years, :months, :weeks, :days, :hours, :minutes, :seconds, :millis</pre>

Default is
```ruby
{ years: "Y", months: "M", weeks: "w" days: "d", hours: "h", minutes: "m", seconds: "s", millis: "ms" }
```
You can singularize separators by supplying a hash e.g
```ruby
days: {value: "days", singular: "day"}
```
By default separators are displayed after the corresponding time unit.
To display them before to the units use this option:
```ruby
seconds: {value: "seconds:", align: :before}
```
results in this:

<pre>
seconds:1
</pre>

####:leading_zeroes

Set to false to remove leading zeroes (e.g 08:00:00 => 8:00:00)

Defaults to <pre>true</pre>.

## Countup

For a reverse countdown starting at 00:00:00 use the countup method using the same options:

```ruby
 <%= countup 1.hour, step: :seconds %>
```

## TODO:

- Everything
- Note to me: How to define a callback, which happens after a complete countdown/-up? 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
