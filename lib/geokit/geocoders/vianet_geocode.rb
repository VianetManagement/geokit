module Geokit
  module Geocoders
  	class VianetGeocode < Geocoder

		  # Use via: Geokit::Geocoders::MyGeocoder.key = 'MY KEY'
		  config :key

		  private

		  def self.do_geocode(address, options = {})
		  	address = address.nil? ? "" : address
		  	address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        query_string = "?q=#{Geokit::Inflector.url_escape(address_str)}"
        base = "https://geocode.vianet.us/places"
        parsed_url = URI.parse("#{base}#{query_string}")

		  	process_with_authorization :json, parsed_url, key
		  end

		  def self.parse_json(result)
		    loc = new_loc
		    return loc if result.nil? || result.empty?

		    loc.success = true
	      loc.city = result.first.dig("city")
	      loc.state = result.first.dig("state_code")
	      loc.state_name = result.first.dig("state_name")
	      loc.lat = result.first.dig("lat")
	      loc.lng = result.first.dig("lon")
	      loc.country_code = "US"
	      return GeoLoc.new if loc.lng.nil? || loc.lat.nil?
	      loc
		  end
		end
  end
end