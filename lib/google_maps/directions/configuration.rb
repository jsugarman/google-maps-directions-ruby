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
    # for more on direction_options
    #
    class Configuration
      attr_accessor :host, :api_key
      attr_reader :direction_options

      def initialize
        @host = host || GoogleMaps::Directions.path
        @api_key = api_key
        @direction_options = default_direction_options.merge(direction_options || {})
      end

      def direction_options=(options = {})
        default_direction_options.merge(options || {})
      end

      private

      def default_direction_options
        { mode: 'driving' }
      end
    end
  end
end
