# frozen_string_literal: true

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
    subject(:directions) { instance.directions(origin: origin, destination: destination, **options) }

    let(:instance) { described_class.new(key) }
    let(:key) { 'not-a-real-api-key' }
    let(:options) { { region: 'uk', alternatives: true } }

    context 'with postcodes with' do
      let(:origin) { 'SW1A 1AA' }
      let(:destination) { 'MK40 1HG' }

      it { is_expected.to be_a(Hash) }
    end
  end
end
