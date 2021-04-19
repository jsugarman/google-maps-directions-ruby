# frozen_string_literal: true

require 'json'

module GoogleMaps
  module Directions
    # Object representating a response from the Google Maps Directions API
    # e.g.
    # result = client.directions(origin: 'an origin', destination: 'a destination', **options)
    # result['status']
    # => 'OK'
    # result.success?
    # => true
    # result.response
    # => { "raw" : { "json" : "response" } }
    #
    class Result
      extend Forwardable

      attr_reader :response, :result

      def_delegator :result, :[]

      def initialize(response)
        @response = response
        @result ||= JSON.parse(response)
      end

      def success?
        result['status'].eql?('OK')
      end
    end
  end
end