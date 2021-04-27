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

      def_delegator 'GoogleMaps::Directions::Request', :get

      def directions(origin:, destination:, **options)
        response = get(origin, destination, **options)
        result = Result.new(response.body)
        return result if result.success?

        handle_error(result)
      end

      private

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
