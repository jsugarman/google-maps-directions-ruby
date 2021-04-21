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
      include Comparable

      attr_reader :route, :leg

      def initialize(route, leg: 0)
        @route = route
        @leg = leg
      end

      def <=>(other)
        value <=> other.value
      end

      # TODO: legs are when waypoints have been setup (without a via:).
      # In such cases the total distance will be the sum of all legs
      #
      def value
        distance['value']
      end

      def text
        distance['text']
      end

      private

      def distance
        @distance ||= route['legs'][leg]['distance']
      end
    end
  end
end
