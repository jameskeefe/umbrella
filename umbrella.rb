# Write your soltuion here!

require "dotenv/load"
require "pry-byebug"
apikey_pirateweather = ENV.fetch("API_PIRATEWEATHER")
apikey_google = ENV.fetch("API_GOOGLEMAPS")

# comment this out for now while working through the code
# user_loc = gets.chomp

user_loc = "Chicago Booth Harper Center"
user_loc = user_loc.gsub(" ","%20")

require "http"
require "json"

url_googleapi = "https://maps.googleapis.com/maps/api/geocode/json?"
google_address = "address=#{user_loc}"
google_key = "&key=#{apikey_google}"
get_google_url = url_googleapi+google_address+google_key

pp get_google_url

data = HTTP.get(get_google_url)

parseddata = JSON.parse(data)

# see what get's parsed
parseddata.keys()

# we care about results not the "status"
parseddata = parseddata.fetch("results")

# see what's in the array fetched by results
parseddata.each_with_index do |obj,i|
  puts "#{i} : #{obj} \n"
end

# only one item in the list actually which is a hast
parseddata = parseddata.at(0)

pp parseddata
pp parseddata.class
pp parseddata.keys()

geometry = parseddata.fetch("geometry")
pp "Geometry type is: #{geometry.class}"
pp geometry.keys()
location = geometry.fetch("location")
pp "Location type is: #{location.class}"
pp location.keys()

lat = location.fetch("lat")
lng = location.fetch("lng")

pp lat
pp lng

url_pirateapi = "https://api.pirateweather.net/forecast/"
pirate_address = "#{lat},#{lng}"
pirate_key = "#{apikey_pirateweather}/"
get_pirate_url = url_pirateapi+pirate_key+pirate_address

pp get_pirate_url

data_pirate = HTTP.get(get_pirate_url)

parsedpirate = JSON.parse(data_pirate)

pp parsedpirate.class
pp parsedpirate.keys()

current = parsedpirate.fetch("currently")
pp current.class
pp current.keys

pp "The current temperature is #{current.fetch("temperature")} degrees F." 
pp "The current conditions are: #{current.fetch("summary")}."



{:hour=>,:percip_prob=>}

hourly = parsedpirate.fetch("hourly")

pp hourly.class
pp hourly.keys

hourly = hourly.fetch("data")

pp hourly.class
pp hourly.length

hourly.each_with_index do (obj,h)
  if h<=12:
    pp "Hour number: #{h}"
    pp "Time: #{hourly.fetch("time")} "
    pp "Precip probability: #{hourly.fetch("precipProbability")} "
    if hourly.fetch("precipProbability")>0.1
      pp "You might want to carry an umbrella! The precipitation probability is: #{hourly.fetch("precipProbability")}, #{h} hours from now."
    end
  end
end

precip_prob = Array.new
precip_prob.push = 

debugger  # then type exit in terminal when done with debugger to exit
pp "end of file"
