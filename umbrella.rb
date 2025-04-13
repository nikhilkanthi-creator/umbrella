# Write your solution below!

# Pull in requirements
require "http"
require "json"
require "dotenv/load"

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")
gmaps_key = ENV.fetch("GMAPS_KEY")

# pp "Where are you?"
# user_location = gets.chomp.gsub(" ", "%20")

user_location = "Chicago"

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
pp current_time
epoch_integer = current_time.to_i
pp epoch_integer

#pp hourly

hourly.each do | hourly_val |
  pp hourly_val
  #summary_var = hourly_val.fetch("summary")
  #pp summary_var
  #current_set = hourly.fetch(hourly_val)
  #precip_prob = current_set.fetch("precipProbability")
  #pp precip_prob
end

pp "Checking the weather at " + user_location
pp "Your coordinatres are " + latitude.to_s + ", " + longitude.to_s
pp "It is currently " + temperature.to_s + " degrees Fahrenheit in " + user_location
