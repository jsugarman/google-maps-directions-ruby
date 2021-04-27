# frozen_string_literal: true

require 'addressable'
require 'faraday'

module GoogleMaps
  module Directions
    # Make request to the Google maps directions API
    #
    # @example simple request
    #   response = Request.get('disneyland', neverland, region: 'us', mode: 'walking')
    #   response.body
    #   =>
    #   {
    #     "geocoded_waypoints": [blah..],
    #     "routes": [blah..],
    #     "status": "OK"
    #   }
    # @param [String] origin: The address or latitude/longitude value from which you wish
    #   to calculate directions.
    # @param [String] destination: The address or latitude/longitude value from which
    #   you wish to calculate directions.
    # @param [kwargs]: one or more options accepted as params on API requests. These will
    #   overide default_options set in config if they are for the same key_word.
    class Request
      extend Forwardable

      attr_accessor :api_key, :default_options

      def_delegator 'GoogleMaps::Directions', :config

      def initialize
        self.api_key = config.api_key
        self.default_options = config.default_options
      end

      def self.get(origin, destination, **options)
        new.get(origin, destination, **options)
      end

      def get(origin, destination, **options)
        uri.query_values = default_options.merge({ key: api_key, origin: origin, destination: destination, **options })
        Faraday.get(uri)
      end

      private

      def uri
        @uri ||= Addressable::URI.parse(directions_path)
      end

      def directions_path
        GoogleMaps::Directions.path
      end
    end
  end
end
