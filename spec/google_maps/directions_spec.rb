# frozen_string_literal: true

RSpec.describe GoogleMaps::Directions do
  describe '.path' do
    subject(:path) { described_class.path }

    it { is_expected.to eql('https://maps.googleapis.com/maps/api/directions/json') }
  end
end
