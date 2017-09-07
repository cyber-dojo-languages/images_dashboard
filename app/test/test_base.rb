ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'minitest/autorun'
require_relative '../src/images_dashboard'

class TestBase < Minitest::Test
  include Rack::Test::Methods

  def app
    ImagesDashboard
  end

  def assert_response(n)
    assert_equal n, last_response.status
  end

  def ok
    200
  end

  def not_found
    404
  end

end
