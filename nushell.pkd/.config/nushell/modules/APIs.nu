# A collection of useful API wrappers

# Wraps the `ipinfo.io` API
export def ip [] {
  http get https://ipinfo.io -H [User-Agent "curl"]
}

# Wraps the wttr.in API to display weather information
# For API details run `http get wttr.in/:help`
#
# Query current weather conditions for any location. Automatically detects your location using IP info when not specified.
# Supports ASCII art (default) or JSON output, Fahrenheit/Celsius, and forecast depths from current to tomorrow.
#
# Examples:
#   `weather`                              # Current weather for detected location
#   `weather "San Francisco"`              # Weather for San Francisco
#   `weather --output json`                # Weather as JSON
#   `weather --temp c "London"`            # London weather in Celsius
#   `weather --forecast today Seattle`     # Today's forecast for Seattle
#   `weather -f tomorrow -d detailed NYC`  # Detailed tomorrow forecast for NYC
export def weather [
  location: string = here # Location: city, airport code, area code, GPS coord, domain name
  --output (-o): string@[ascii json] = ascii # Output format
  --temp (-t): string@[f c] = f # Temperature unit
  --detail (-d): string@[simple detailed] = simple # Weather report detail
  --forecast (-f): string@[current today tomorrow] = current # Forecast depth
] {
  let location = if $location == here {
    http get ipinfo.io/city | str trim
  } else {$location}
  | str replace " " "+"
  let detail = match $detail {
    simple => "n",
    detailed => ""
  }
  let forecast = match $forecast {
    current => "0",
    today => "1",
    tomorrow => "2"
  }
  let output = match $output {
    ascii => "",
    json => "&format=j1"
  }
  http get $"wttr.in/($location)?uF($temp)($forecast)($detail)($output)"
}
