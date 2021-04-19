# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Client do
  it { is_expected.to respond_to(:api_key) }
  it { is_expected.to respond_to(:directions) }

  describe '.new' do
    context 'with api key set in config' do
      subject(:client) { described_class.new }

      before do
        GoogleMaps::Directions.configure do |config|
          config.api_key = 'my-api-key-from-config'
        end
      end

      it { expect(client).to have_attributes(api_key: 'my-api-key-from-config') }
    end

    context 'with api key set call' do
      subject(:client) { described_class.new('my-api-key-from-args') }

      it { expect(client).to have_attributes(api_key: 'my-api-key-from-args') }
    end
  end

  describe '#directions' do
    subject(:directions) { client.directions(**params, **options) }

    let(:client) { described_class.new(api_key) }
    let(:api_key) { 'not-a-real-api-key' }
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

      # TODO: to be moved to a distance object?!
      it {
        distance = directions['routes'][0]['legs'][0]['distance']['value']
        expect(distance).to be_an(Integer)
      }
    end

    context 'with invalid api key', request_denied: true do
      it {
        expect { directions }.to raise_error GoogleMaps::Directions::RequestDeniedError, /API key is invalid/
      }
    end

    # TODO: with invalid origin
    # TODO: with invalid destination
    # TODO: with invalid option
    # TODO: with origin as array
    # TODO: with destination as array
  end
end
