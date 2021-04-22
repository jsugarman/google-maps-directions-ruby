# frozen_string_literal: true

module GoogleMaps
  module Directions
    # Configuration of GoogleMaps Directions API client
    #
    # For use in initializer
    # e.g.
    # # <rails_root>/config/initializers/google_maps-directions.rb
    # GoogleMaps::Directions.configuration do |config|
    #   config.api_key = ENV['GOOGLEMAPS_API_KEY']
    #   config.direction_options = { region: 'uk', alternatives: true, mode: 'driving' }
    # end
    #
    # see https://developers.google.com/maps/documentation/directions/get-directions#optional-parameters
    # for more on available options
    #
    class Configuration
      attr_accessor :api_key, :default_options

      def initialize
        @default_options = {}
      end
    end
  end
end
