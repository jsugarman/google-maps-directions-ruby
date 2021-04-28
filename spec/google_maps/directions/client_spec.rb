# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Client do
  it { is_expected.to respond_to(:directions) }

  describe '#directions' do
    subject(:directions) { client.directions(**params, **options) }

    let(:client) { described_class.new }
    let(:params) { { origin: 'SW1A 1AA', destination: 'MK40 1HG' } }
    let(:options) { {} }

    let(:expected_uri) do
      uri = Addressable::URI.parse('https://maps.googleapis.com/maps/api/directions/json')
      uri.query_values = { key: 'not-a-real-api-key', origin: 'SW1A 1AA', destination: 'MK40 1HG' }
      uri
    end

    context 'with valid request and response', valid_response: true do
      it {
        directions
        expect(a_request(:get, expected_uri))
          .to have_been_made.once
      }

      it { is_expected.to be_a(GoogleMaps::Directions::Result) }
    end

    context 'with invalid api key', request_denied: true do
      it {
        expect { directions }.to raise_error GoogleMaps::Directions::RequestDenied, /API key is invalid/
      }
    end

    context 'with invalid origin request', invalid_origin_request: true do
      it {
        expect { directions }
          .to raise_error GoogleMaps::Directions::InvalidRequest, /Invalid request. Missing the 'origin' parameter/
      }
    end

    context 'with invalid destination request', invalid_destination_request: true do
      it {
        expect { directions }
          .to raise_error GoogleMaps::Directions::InvalidRequest, /Invalid request. Missing the 'destination' parameter/
      }
    end

    context 'when unexpected error with error_message', unexpected_error: true do
      it {
        expect { directions }
          .to raise_error GoogleMaps::Directions::Error, /UNEXPECTED_ERROR: oops, something went wrong!/
      }
    end

    context 'when unexpected error without error_message', unexpected_error_without_message: true do
      it {
        expect { directions }
          .to raise_error GoogleMaps::Directions::Error, /UNEXPECTED_ERROR: status from directions API/
      }
    end

    # TODO: handle invalid statuses
    #
    # see https://developers.google.com/maps/documentation/directions/get-directions#StatusCodes
    # for list of possible statuses/failures
    #
    # TODO: with invalid option
    # TODO: with origin as array
    # TODO: with destination as array
  end
end
