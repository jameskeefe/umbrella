# Write your soltuion here!

require "dotenv/load"
require "pry-byebug"
apikey_pirateweather = ENV.fetch("API_PIRATEWEATHER")
apikey_google = ENV.fetch("API_GOOGLEMAPS")

puts "Hello! I can help you decide if you need an umbrella today."
puts
puts "Where are you?"
puts

user_loc = gets.chomp
puts

puts "Checking the weather at #{user_loc}"
puts

user_loc = user_loc.gsub(" ","%20")

require "http"
require "json"
require "ascii_charts"

url_googleapi = "https://maps.googleapis.com/maps/api/geocode/json?"
google_address = "address=#{user_loc}"
google_key = "&key=#{apikey_google}"
get_google_url = url_googleapi+google_address+google_key

# pp get_google_url

data = HTTP.get(get_google_url)

parseddata = JSON.parse(data)

# see what get's parsed
parseddata.keys()

# we care about results not the "status"
parseddata = parseddata.fetch("results")

# see what's in the array fetched by results
parseddata.each_with_index do |obj,i|
  # puts "#{i} : #{obj} \n"
end

# only one item in the list actually which is a hast
parseddata = parseddata.at(0)

# pp parseddata
# pp parseddata.class
# pp parseddata.keys()

geometry = parseddata.fetch("geometry")
# pp "Geometry type is: #{geometry.class}"
# pp geometry.keys()
location = geometry.fetch("location")
# pp "Location type is: #{location.class}"
# pp location.keys()

lat = location.fetch("lat")
lng = location.fetch("lng")

pp "Your location coordinates are #{lat} and #{lng}."


url_pirateapi = "https://api.pirateweather.net/forecast/"
pirate_address = "#{lat},#{lng}"
pirate_key = "#{apikey_pirateweather}/"
get_pirate_url = url_pirateapi+pirate_key+pirate_address

# pp get_pirate_url

data_pirate = HTTP.get(get_pirate_url)

parsedpirate = JSON.parse(data_pirate)

# pp parsedpirate.class
# pp parsedpirate.keys()

current = parsedpirate.fetch("currently")
# pp current.class
# pp current.keys

pp "The current temperature is #{current.fetch("temperature")} degrees F." 
pp "The current conditions are: #{current.fetch("summary")}."

hourly = parsedpirate.fetch("hourly")

# pp hourly.class
# pp hourly.keys

hourly = hourly.fetch("data")

# pp hourly.class
# pp hourly.length

# warning is a boolean that will tell us if we need an umbrella in the next 12 hours when we iterate through our loop
# warned = false

# hourly.each_with_index do |obj,h|
#   if (h <= 12)
#     pp "Hour number: #{h}"
#     pp "Time: #{obj.fetch("time")} "
#     pp "Precip probability: #{obj.fetch("precipProbability")} "
#     if obj.fetch("precipProbability")>0.1
#       if warned
#         warned = true
#         pp "You might want to carry an umbrella!"
#         pp "The precipitation probability is: #{obj.fetch("precipProbability")}, #{h} hours from now."
#       else
#         pp "The precipitation probability is: #{obj.fetch("precipProbability")}, #{h} hours from now."
#       end
#     end
#   end
# end
# if warned = false
#   pp "You probably won't need an umbrella today. That's great!"
# end


# this is a nested list to store hourly weather in 
hourly_weather = Array.new()

# should we warn the person to bring an umbrella
warn = false

hourly.each_with_index do |obj,h|
  if (h <= 12 && h >0)
    hourly_weather.push([h,obj.fetch("precipProbability")*100])

    if obj.fetch("precipProbability")>0.1
      warn=true
    end
  end
end

puts AsciiCharts::Cartesian.new(hourly_weather, :bar => true, :hide_zero => true).draw

if warn
  pp "You might want to carry an umbrella!"
else 
  pp "You probably won't need an umbrella today. That's great!"
end


# debugger  # then type exit in terminal when done with debugger to exit
# pp "end of file"
