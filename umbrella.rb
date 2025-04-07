# Write your soltuion here!

require "dotenv/load"
apikey_pirateweather = ENV.fetch("API_PIRATEWEATHER")
apikey_google = ENV.fetch("API_GOOGLEMAPS")

# comment this out for now while working through the code
# user_loc = gets.chomp

user_loc = "Chicago Booth Harper Center"

require "http"
require "json"

url_googleapi = "https://maps.googleapis.com/maps/api/geocode/json?"
google_address = "address=#{user_loc}"
google_key = "&key=#{apikey_google}"
get_google_url = url_googleapi+google_address+google_key

pp get_google_url


user_lat = lat
user_lng = lng

url_pirateapi = "https://api.pirateweather.net/forecast/"
pirate_address = "#{lat},#{lng}"
pirate_key = "#{apikey_pirateweather}/"
get_pirate_url url_pirateapi+pirate_key+pirate_address

pp get_pirate_url

pp "end of file"
