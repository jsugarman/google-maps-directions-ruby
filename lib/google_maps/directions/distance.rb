# frozen_string_literal: true

module GoogleMaps
  module Directions
    # Object representating a single route distance from the
    # Google Maps Directions API
    # e.g.
    # result = client.directions(origin: 'an origin', destination: 'a destination', **options)
    # distance = result.distances.first
    # distance.value
    # => 216312
    # distance.text
    # => '216 km'
    #
    class Distance
      attr_reader :route, :leg

      def initialize(route, leg: 0)
        @route = route
        @leg = leg
      end

      # TODO: legs are when waypioints have been setup (without a via:).
      # In such cases the total distance will be the sum of all legs
      #
      def value
        route['legs'][leg]['distance']['value']
      end

      def text
        route['legs'][leg]['distance']['text']
      end
    end
  end
end
