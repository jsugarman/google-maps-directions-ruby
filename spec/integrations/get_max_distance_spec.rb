# frozen_string_literal: true

require 'google-maps-directions'
require 'support/directions_stubs'

RSpec.describe 'Get distances for journey', type: :feature do
  let(:client) { GoogleMaps::Directions::Client.new }
  let(:options) { { region: 'uk', alternatives: true } }
  let(:result) { client.directions(origin: 'disneyland', destination: 'neverland', **options) }

  context 'with single route with one leg', valid_response: true do
    specify 'max distance same as min distance' do
      longest = result.distances.max
      shortest = result.distances.min
      expect(longest).to be shortest
      expect(longest.value).to be shortest.value
    end
  end

  context 'with mutiple routes with one leg each', valid_response_with_alternatives: true do
    specify 'max distance different from min distance' do
      longest = result.distances.max
      shortest = result.distances.min
      expect(longest).not_to be(shortest)
      expect(longest.value).not_to be(shortest.value)
    end
  end

  context 'with single route with multiple legs each', valid_response_with_multiple_legs: true do
    let(:options) { { region: 'uk', alternatives: true, waypoints: 'MK40 1AJ' } }
    let(:result) { client.directions(origin: 'SW1A 1AA', destination: 'DY1 3HQ', **options) }
    let(:total_distance_from_stub) { 242_926 }

    it 'returns sum of leg distance' do
      expect(result.distances.first.value).to be total_distance_from_stub
    end
  end

  # context 'with multiple routes with multiple legs each' do
  # end
end
