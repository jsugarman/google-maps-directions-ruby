# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Client do
  it { is_expected.to respond_to(:api_key, :api_key=) }
  it { is_expected.to respond_to(:default_options, :default_options=) }
  it { is_expected.to respond_to(:directions) }

  describe '.new' do
    context 'with api key set in config' do
      subject(:client) { described_class.new }

      around do |example|
        GoogleMaps::Directions.configure do |config|
          old_api_key = config.api_key
          config.api_key = 'my-api-key-from-config'
          example.run
          config.api_key = old_api_key
        end
      end

      it { is_expected.to have_attributes(api_key: 'my-api-key-from-config') }
    end

    context 'with api key set by writer' do
      subject(:client) { described_class.new }

      before do
        client.api_key = 'my-api-key-by-writer'
      end

      it { is_expected.to have_attributes(api_key: 'my-api-key-by-writer') }
    end

    context 'when default options set in config' do
      subject(:client) { described_class.new }

      around do |example|
        GoogleMaps::Directions.configure do |config|
          old_default_options = config.default_options
          config.default_options = { region: 'us', alternatives: true }
          example.run
          config.default_options = old_default_options
        end
      end

      it { is_expected.to have_attributes(default_options: { region: 'us', alternatives: true }) }
    end
  end

  describe '#directions' do
    subject(:directions) { client.directions(**params, **options) }

    let(:client) { described_class.new }
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

    context 'with default options set in config', valid_response_with_alternatives: true do
      let(:params) { { origin: 'SW1A 1AA', destination: 'DY1 3HQ' } }

      let(:expected_uri) do
        uri = Addressable::URI.parse('https://maps.googleapis.com/maps/api/directions/json')
        uri.query_values = { key: 'not-a-real-api-key',
                             origin: 'SW1A 1AA',
                             destination: 'DY1 3HQ',
                             region: 'uk',
                             alternatives: true }
        uri
      end

      around do |example|
        GoogleMaps::Directions.configure do |config|
          old_default_options = config.default_options
          config.default_options = { region: 'uk', alternatives: true }
          example.run
          config.default_options = old_default_options
        end
      end

      it 'request includes default options set in config' do
        directions
        expect(a_request(:get, expected_uri))
          .to have_been_made.once
      end
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
