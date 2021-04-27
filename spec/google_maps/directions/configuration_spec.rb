# frozen_string_literal: true

RSpec.describe GoogleMaps::Directions::Configuration do
  it { is_expected.to respond_to(:api_key, :api_key=, :default_options, :default_options=) }
end
