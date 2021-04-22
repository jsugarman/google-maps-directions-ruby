# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Request do
  subject(:request) { described_class.new }

  it { is_expected.to respond_to(:api_key, :api_key=) }
  it { is_expected.to respond_to(:default_options, :default_options=) }
  it { expect(described_class).to respond_to(:get) }
  it { is_expected.to respond_to(:get) }

  describe '#api_key' do
    context 'with api key set in config' do
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
      before { request.api_key = 'my-api-key-by-writer' }

      it { is_expected.to have_attributes(api_key: 'my-api-key-by-writer') }
    end
  end

  describe '#get' do
    context 'with default options set in config', valid_response_with_alternatives: true do
      let(:expected_uri) do
        'https://maps.googleapis.com/maps/api/directions/json?alternatives=true&destination=DY1 3HQ&key=not-a-real-api-key&origin=SW1A 1AA&region=uk'
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
        request.get('SW1A 1AA', 'DY1 3HQ')
        expect(a_request(:get, expected_uri))
          .to have_been_made.once
      end
    end

    context 'with default options set in query', valid_response_with_alternatives: true do
      let(:options) { { region: 'us', mode: 'walking' } }

      let(:expected_uri) do
        'https://maps.googleapis.com/maps/api/directions/json?destination=neverland&key=not-a-real-api-key&mode=walking&origin=disneyland&region=us'
      end

      it 'request includes default options set in config' do
        request.get('disneyland', 'neverland', options)
        expect(a_request(:get, expected_uri))
          .to have_been_made.once
      end
    end
  end
end
