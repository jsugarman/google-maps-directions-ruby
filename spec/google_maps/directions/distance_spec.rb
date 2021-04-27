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

  context 'when comparing distances' do
    let(:result) do
      { routes:
        [{ 'legs' => [{ 'distance' => { 'value' => 100_000 } },
                      { 'distance' => { 'value' => 100_000 } }] },
         { 'legs' => [{ 'distance' => { 'value' => 100_000 } },
                      { 'distance' => { 'value' => 100_001 } }] },
         { 'legs' => [{ 'distance' => { 'value' => 200_000 } }] }]
      }
    end

    describe '#<=>' do
      let(:distance1) { described_class.new(result[:routes][0]) }
      let(:distance2) { described_class.new(result[:routes][1]) }
      let(:distance3) { described_class.new(result[:routes][2]) }
      let(:distances) { [distance1, distance2, distance3] }

      specify { expect(distance1).to be < distance2 }
      specify { expect(distance2).to be > distance1 }
      specify { expect(distance3).to eq distance1 }

      specify { expect(distances.min).to be distance1 }
      specify { expect(distances.max).to be distance2 }
    end
  end
end
