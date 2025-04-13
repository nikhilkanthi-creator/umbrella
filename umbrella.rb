# Write your solution below!

# Pull in requirements
require "http"
require "json"
require "dotenv/load"
require "ascii_charts"

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

 pp "Where are you?"
 user_location = gets.chomp.gsub(" ", "%20")

# user_location = "Chicago"

# assemble URL for GMaps, get the output into parsed JSON
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + gmaps_key
maps_response = HTTP.get(gmaps_url)
parse_response_maps = JSON.parse(maps_response)

results_lvl1 = parse_response_maps.fetch("results")
results_lvl2 = results_lvl1.at(0)
results_lvl3 = results_lvl2.fetch("geometry")
results_lvl4 = results_lvl3.fetch("location")
latitude = results_lvl4.fetch("lat")
longitude = results_lvl4.fetch("lng")
# pp latitude
# pp longitude

#Assemble the URL for the weather API, get the output into a parsed JSON object
pirate_weather_url = "https://api.pirateweather.net/forecast/" + pirate_weather_key + "/" + latitude.to_s + "," + longitude.to_s
# pp pirate_weather_url

weather_response = HTTP.get(pirate_weather_url)
parse_response_weather = JSON.parse(weather_response)

# now retrieve current weather 
# pp parse_response_weather.keys
results2_l1 = parse_response_weather.fetch("currently")
temperature = results2_l1.fetch("temperature")

# now retrieve weather the next hour
hourly = parse_response_weather.fetch("hourly")
current_time = Time.now
# pp current_time
epoch_integer = current_time.to_i
# pp epoch_integer
hourly_data = hourly.fetch("data")
next_twelve_hours = hourly_data[1..12]
#pp hourly_data.class
count = 0
rainy_count = 0
pairs = []
#pp hourly_data
pp "Checking the weather at " + user_location
pp "Your coordinatres are " + latitude.to_s + ", " + longitude.to_s
pp "It is currently " + temperature.to_s + " degrees Fahrenheit in " + user_location


next_twelve_hours.each do | hourly_val |
  count = count + 1

  #pp "you are at " + count.to_s
  #time_raw = hourly_val.fetch("time")
  #time_final = Time.at(time_raw)
  #pp time_final
  #summary_var = hourly_val.fetch("summary")
  #pp summary_var
  precip_prob = hourly_val.fetch("precipProbability")
  pairs.push([count, precip_prob])
  # pp precip_prob
  if precip_prob.to_f > 0.1
    pp "It's gonna rain " + count.to_s + " hours from now, dude."
    pp "The probability is " + precip_prob.to_s
    rainy_count = rainy_count + 1
  end
end

if rainy_count > 0
  pp "You should carry an umbrella"
else
  pp "No need to carry an umbrella"
end  
pp "Look at this chart of likelihood to rain I drew for you."
puts AsciiCharts::Cartesian.new(pairs, :bar=> true).draw
