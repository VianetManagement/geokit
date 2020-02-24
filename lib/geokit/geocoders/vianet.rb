module Geokit
  module Geocoders
  	class VianetGeocoder < Geocoder

		  # Use via: Geokit::Geocoders::MyGeocoder.key = 'MY KEY'
		  config :key

		  private

		  def submit_url(address)
		  	address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        query_string = "?q=#{Geokit::Inflector.url_escape(address_str)}"
        base = "https://geocode-api.vianet.us/places"
        parsed_url = URI.parse("#{base}#{query_string}")
		  end

		  def self.do_geocode(address, options = {})
		  	
		  	process_with_authorization :json, submit_url(address), key
		  end

		  def self.parse_json(json)
		    loc = new_loc

		    begin
		      result = JSON.parse(json)

		      loc.success = true
		      loc.city = result.first.dig("_source", "name")
		      loc.state = result.first.dig("_source", "admin1_code")
		      loc.state_name = result.first.dig("_source", "admin1_name")
		      loc.lat = result.first.dig("_source", "location", "lat")
		      loc.lng = result.first.dig("_source", "location", "lon")
		      loc.country_code = result.first.dig("_source", "country_code") || "US"
		      loc
		    rescue JSON::ParserError => e
		      return new_loc
		    end
		  end
		end
  end
end