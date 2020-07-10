require 'test_helper'

class HelloControllerTest < ActionDispatch::IntegrationTest
  test "should get say_hello" do
    get hello_say_hello_url
    assert_response :success
  end

end
