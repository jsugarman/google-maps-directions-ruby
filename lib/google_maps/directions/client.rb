# frozen_string_literal: true

module GoogleMaps
  module Directions
    # Target functionality
    #
    # @example
    #   client = GoogleMaps::Directions::Client.new(api_key: 'my-api-key')
    #   options = { region: 'uk', alternatives: true }
    #   result = client.directions(origin: 'SW1A 1AA', destination: 'SW1A 2AA', options)
    #   distance = result.distances.max
    #   distance.value
    #     => 9999 [in units/metres]
    #   distance.text
    #     => '10 km' [in units/imperial/metric (miles/kilometres)]
    #
    class Client
      extend Forwardable

      attr_accessor :error_handler

      def_delegator 'GoogleMaps::Directions::Request', :get

      def initialize(error_handler: ResultError)
        self.error_handler = error_handler
      end

      def directions(origin:, destination:, **options)
        response = get(origin, destination, **options)
        result = Result.new(response.body)
        return result if result.success?

        error_handler.for(result)
      end
    end
  end
end
