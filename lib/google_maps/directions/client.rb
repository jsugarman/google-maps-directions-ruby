# frozen_string_literal: true

require 'addressable'
require 'faraday'
require 'json'

module GoogleMaps
  module Directions
    # Target functionality
    #
    # client = GoogleMaps::Directions::Client.new(api_key: 'my-api-key')
    # options = { region: 'uk', alternatives: true }
    # client.directions(origin: 'SW1A 1AA', destination: 'SW1A 2AA', options)
    #
    # request => https://maps.googleapis.com/maps/api/directions/json?origin=SW1A%201AA&destination=SW1A%202AA&key=my-api-key
    # => hash of directions <= json response
    #
    class Client
      attr_accessor :api_key

      def initialize(api_key = nil)
        self.api_key = api_key || GoogleMaps::Directions.config.api_key
      end

      def directions(origin:, destination:, **options)
        uri.query_values = { key: api_key, origin: origin, destination: destination, **options }
        json = Faraday.get(uri).body
        JSON.parse(json)
      end

      private

      def uri
        @uri ||= Addressable::URI.parse(GoogleMaps::Directions.path)
      end
    end
  end
end
