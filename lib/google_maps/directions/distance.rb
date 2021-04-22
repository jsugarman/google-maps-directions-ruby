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

      attr_reader :route

      def initialize(route)
        @route = route
      end

      def <=>(other)
        value <=> other.value
      end

      def value
        distance['value']
      end

      def text
        distance['text']
      end

      private

      def distance
        @distance ||= { 'value' => total, 'text' => total_units }
      end

      def total
        @total ||= route['legs'].sum { |leg| leg['distance']['value'] }
      end

      # TODO: need to handle units dynamically (i.e. metric/imperial, km/miles)
      # https://developers.google.com/maps/documentation/directions/get-directions#unit-systems
      #
      def total_units
        "#{(total / 1000).round} km"
      end
    end
  end
end
