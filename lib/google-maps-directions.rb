# frozen_string_literal: true

require_relative 'google_maps/directions'
require_relative 'google_maps/directions/version'
require_relative 'google_maps/directions/errors'
require_relative 'google_maps/directions/configuration'
require_relative 'google_maps/directions/distance'
require_relative 'google_maps/directions/request'
require_relative 'google_maps/directions/result'
require_relative 'google_maps/directions/client'

# Container for GoogleMaps level functionality
#
module GoogleMaps
  def self.path
    'https://maps.googleapis.com/maps/api'
  end

  # Container for GoogleMaps::Directions level functionality
  #
  module Directions
    class << self
      attr_writer :configuration

      def path
        "#{GoogleMaps.path}/directions/json"
      end

      def configuration
        @configuration ||= Configuration.new
      end
      alias config configuration

      def configure
        yield(configuration) if block_given?
        configuration
      end

      def reset
        @configuration = Configuration.new
      end
    end
  end
end
