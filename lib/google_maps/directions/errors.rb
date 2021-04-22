# frozen_string_literal: true

# StandardError wrapper for this gem
#
module GoogleMaps
  module Directions
    # Base error for lib
    #
    class Error < StandardError; end

    # Raised when status REQUEST_DENIED in API response
    #
    class RequestDeniedError < Error; end
  end
end
