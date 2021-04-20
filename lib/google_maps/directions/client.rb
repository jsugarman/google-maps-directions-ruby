# frozen_string_literal: true

require 'addressable'
require 'faraday'

module GoogleMaps
  module Directions
    # Target functionality
    #
    # client = GoogleMaps::Directions::Client.new(api_key: 'my-api-key')
    # options = { region: 'uk', alternatives: true }
    # result = client.directions(origin: 'SW1A 1AA', destination: 'SW1A 2AA', options)
    # distance = result.distances.max
    # distance.value
    # => 9999 [in units/metres]
    # distance.text
    # => 9999 [in units/imperial/metric (miles/kilometres)]
    # direction.longest/max
    # direction.shortest/min
    #
    class Client
      extend Forwardable

      attr_accessor :api_key, :adaptor, :default_options

      def_delegator 'GoogleMaps::Directions', :config

      def initialize(adaptor: Faraday)
        self.adaptor = adaptor
        self.api_key = config.api_key
        self.default_options = config.default_options
      end

      def directions(origin:, destination:, **options)
        response = request(origin, destination, **options)
        result = GoogleMaps::Directions::Result.new(response.body)
        return result if result.success?

        handle_error(result)
      end

      private

      def request(origin, destination, **options)
        uri.query_values = default_options.merge({ key: api_key, origin: origin, destination: destination, **options })
        adaptor.get(uri)
      end

      def uri
        @uri ||= Addressable::URI.parse(directions_path)
      end

      def directions_path
        GoogleMaps::Directions.path
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
    end
  end
end
