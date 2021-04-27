# frozen_string_literal: true

require 'support/directions_stubs'

RSpec.describe GoogleMaps::Directions::Result do
  subject(:result) { described_class.new(response) }

  let(:response) { '{ "raw" : "json" }' }

  it { is_expected.to respond_to(:response, :result, :success?, :routes) }

  describe '#[]' do
    subject { result[key] }

    context 'when accessing existing key' do
      let(:response) { '{ "status" : "OK" }' }
      let(:key) { 'status' }

      it { is_expected.to eql('OK') }
    end

    context 'when accessing non-existent key' do
      let(:key) { 'foo' }

      it { is_expected.to be_nil }
    end
  end

  describe '#fetch' do
    subject { result.fetch(key, 'bar') }

    let(:response) { '{ "status" : "OK" }' }

    context 'when accessing existing key' do
      let(:key) { 'status' }

      it { is_expected.to eql('OK') }
    end

    context 'when accessing non-existent key' do
      let(:key) { 'foo' }

      it { is_expected.to eql('bar') }
    end
  end

  describe '#success?' do
    subject { result.success? }

    context 'when status key has OK value' do
      let(:response) { '{ "status" : "OK" }' }
      let(:key) { 'status' }

      it { is_expected.to be_truthy }
    end

    context 'when status key has other value' do
      let(:response) { '{ "status" : "REQUEST_DENIED" }' }

      it { is_expected.to be_falsy }
    end

    context 'when status key does not exist' do
      let(:response) { '{ "other" : "WHATEVER" }' }

      it { is_expected.to be_falsy }
    end
  end

  describe '#distances' do
    subject(:distances) { result.distances }

    context 'with one route' do
      let(:response) { read_stub('valid_response') }

      it {
        expect(distances).to all(be_a(GoogleMaps::Directions::Distance))
      }
    end

    context 'with multiple routes' do
      let(:response) { read_stub('valid_response_with_alternatives') }

      it {
        expect(distances).to all(be_a(GoogleMaps::Directions::Distance))
      }
    end
  end
end
