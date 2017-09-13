require_relative './test_base'

class HomeTest < TestBase

  def test_page_displays
    get '/home'
    assert_response ok
  end

end
