# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Distance do
  subject(:distance) { described_class.new(route) }

  let(:route) do
    { 'legs' => [{ 'distance' => { 'text' => '216 km',
                                   'value' => 216_312 } }] }
  end

  describe '#value' do
    subject(:value) { distance.value }

    it { is_expected.to be 216_312 }
  end

  describe '#text' do
    subject(:text) { distance.text }

    it { is_expected.to eql '216 km' }
  end
end
