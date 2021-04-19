# frozen_string_literal: true

require 'addressable'
require 'faraday'

module GoogleMaps
  module Directions
    # Target functionality
    #
    # client = GoogleMaps::Directions::Client.new(api_key: 'my-api-key')
    # options = { region: 'uk', alternatives: true }
    # direction = client.directions(origin: 'SW1A 1AA', destination: 'SW1A 2AA', options)
    # direction.longest/max
    # direction.shortest/min
    #
    class Client
      attr_accessor :api_key

      def initialize(api_key = nil)
        self.api_key = api_key || GoogleMaps::Directions.config.api_key
      end

      def directions(origin:, destination:, **options)
        uri.query_values = { key: api_key, origin: origin, destination: destination, **options }
        response = request(uri)

        result = GoogleMaps::Directions::Result.new(response)
        return result if result.success?

        handle_error(result)
      end

      private

      def request(uri)
        Faraday.get(uri).body
      end

      def handle_error(result)
        case result['status']
        when 'OK'
          nil
        when 'REQUEST_DENIED'
          raise RequestDeniedError, result['error_message']
        else
          raise Error, result.fetch('error_message',
                                    "#{result['status']} status from directions API")
        end
      end

      def uri
        @uri ||= Addressable::URI.parse(directions_path)
      end

      def directions_path
        GoogleMaps::Directions.path
      end
    end
  end
end
