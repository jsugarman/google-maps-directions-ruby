# frozen_string_literal: true

module GoogleMaps
  module Directions
    # Error handling factory for failed requests
    #
    class ResultError
      def self.for(result)
        case result['status']
        when 'OK'
          nil
        when 'REQUEST_DENIED'
          raise RequestDenied, result['error_message']
        when 'INVALID_REQUEST'
          raise InvalidRequest, result['error_message']
        else
          raise Error, "#{result['status']}: #{result.fetch('error_message', 'status from directions API')}"
        end
      end
    end
  end
end
