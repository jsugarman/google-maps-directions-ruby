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
    class RequestDenied < Error; end

    # Raised when status INVALID_REQUEST in response - origin or destination not provided
    #
    class InvalidRequest < Error; end
  end
end
