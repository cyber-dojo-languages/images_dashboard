require_relative './test_base'

class HomeTest < TestBase

  def test_page_displays
    get '/'
    assert_response ok
  end

end
