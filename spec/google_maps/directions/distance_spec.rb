# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.shared_context 'with single leg' do
  let(:route) do
    { 'legs' => [{ 'distance' => { 'text' => '201 km',
                                   'value' => 201_001 } }] }
  end
end

RSpec.shared_context 'with mutiple legs' do
  let(:route) do
    { 'legs' => [{ 'distance' => { 'text' => '201 km',
                                   'value' => 201_001 } },
                 { 'distance' => { 'text' => '201 km',
                                   'value' => 201_001 } }] }
  end
end

RSpec.describe GoogleMaps::Directions::Distance do
  subject(:distance) { described_class.new(route) }

  describe '#value' do
    subject(:value) { distance.value }

    context 'with single leg' do
      include_context 'with single leg'

      it { is_expected.to be 201_001 }
    end

    context 'with multiple legs' do
      include_context 'with mutiple legs'

      it { is_expected.to be 402_002 }
    end
  end

  describe '#text' do
    subject(:text) { distance.text }

    context 'with single leg' do
      include_context 'with single leg'

      it { is_expected.to eql '201 km' }
    end

    context 'with multiple legs' do
      include_context 'with mutiple legs'

      it { is_expected.to eql '402 km' }
    end
  end
end
