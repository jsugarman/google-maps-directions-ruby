# frozen_string_literal: true

# StandardError wrapper for this gem
#
module GoogleMaps
  module Directions
    class Error < StandardError; end

    class RequestDeniedError < Error; end
  end
end
