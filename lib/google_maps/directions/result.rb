# frozen_string_literal: true

require 'json'

module GoogleMaps
  module Directions
    # Object representating a response from the Google Maps Directions API
    #
    # @example
    #   result = client.directions(origin: 'an origin', destination: 'a destination')
    #   result['status']
    #     => 'OK'
    #   result.success?
    #     => true
    #   result.response
    #     => { "raw" : { "json" : "response" } }
    #
    class Result
      extend Forwardable

      attr_reader :response, :result

      def_delegators :result, :[], :fetch

      def initialize(response)
        @response = response
        @result ||= JSON.parse(response)
      end

      def success?
        result['status'].eql?('OK')
      end

      def routes
        result['routes']
      end

      def distances
        @distances ||= routes.map { |route| Distance.new(route) }
      end
    end
  end
end
