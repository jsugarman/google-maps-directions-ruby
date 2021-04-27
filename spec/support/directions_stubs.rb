# frozen_string_literal: true

# To make real requests you can use this within a
# specific describe or context block and then
# store the result in a new stub.
#
# around do |example|
#   WebMock.allow_net_connect!
#   GoogleMaps::Directions.configure do |config|
#     old_default_options = config.default_options
#     old_api_Key = config.api_key
#     config.default_options = { region: 'uk', alternatives: true }
#     config.api_key = ENV['GOOGLEMAPS_API_KEY']
#     example.run
#     config.api_key = old_api_Key
#     config.default_options = old_default_options
#   end
#   WebMock.disable_net_connect!
# end
#

RSpec.configure do |config|
  config.before(:each, valid_response: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: read_stub('valid_response'),
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, valid_response_with_alternatives: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: read_stub('valid_response_with_alternatives'),
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, valid_response_with_multiple_legs: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: read_stub('valid_response_with_multiple_legs'),
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, request_denied: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: status_request_denied,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, invalid_origin_request: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: status_invalid_origin_request,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, invalid_destination_request: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: status_invalid_destination_request,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, unexpected_error: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: status_unexpected_error,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  config.before(:each, unexpected_error_without_message: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: status_unexpected_error_without_message,
        headers: { 'Content-Type' => 'application/json; charset=utf-8' }
      )
  end

  def read_stub(file_name)
    File.read("./spec/fixtures/stubs/#{file_name}.json")
  end

  def status_ok
    <<~JSON
      {
        "geocoded_waypoints": [],
        "routes": [],
        "status": "OK"
      }
    JSON
  end

  def status_request_denied
    <<~JSON
      {
        "error_message": "The provided API key is invalid.",
        "routes": [],
        "status": "REQUEST_DENIED"
      }
    JSON
  end

  def status_invalid_origin_request
    <<~JSON
      {
        "error_message": "Invalid request. Missing the 'origin' parameter.",
        "routes": [],
        "status": "INVALID_REQUEST"
      }
    JSON
  end

  def status_invalid_destination_request
    <<~JSON
      {
        "error_message": "Invalid request. Missing the 'destination' parameter.",
        "routes": [],
        "status": "INVALID_REQUEST"
      }
    JSON
  end

  def status_unexpected_error
    <<~JSON
      {
        "error_message": "oops, something went wrong!",
        "routes": [],
        "status": "UNEXPECTED_ERROR"
      }
    JSON
  end

  # TODO: check whether API could even raise this or similar
  def status_unexpected_error_without_message
    <<~JSON
      {
        "status": "UNEXPECTED_ERROR"
      }
    JSON
  end
end
