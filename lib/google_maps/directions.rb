# frozen_string_literal: true

module GoogleMaps
  # Container for GoogleMaps::Directions level functionality
  #
  module Directions
    class << self
      attr_writer :configuration

      def path
        "#{GoogleMaps.path}/directions/json"
      end

      def configure
        yield(configuration) if block_given?
        configuration
      end

      def configuration
        self.configuration ||= Configuration.new
      end
      alias config configuration
    end
  end
end
