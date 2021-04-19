# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, valid_response: true) do
    stub_request(:get, %r{https://maps.googleapis.com/maps/api/directions/json\?.*})
      .to_return(
        status: 200,
        body: valid_response,
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

  def valid_response
    File.read('./spec/fixtures/stubs/valid_response.json')
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

  def status_ok
    <<~JSON
      {
        "geocoded_waypoints": [],
        "routes": [],
        "status": "OK"
      }
    JSON
  end
end
