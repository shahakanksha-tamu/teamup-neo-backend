require "test_helper"

class SessionManagerControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get session_manager_login_url
    assert_response :success
  end

  test "should get logout" do
    get session_manager_logout_url
    assert_response :success
  end

  test "should get google_ouath_callback_handler" do
    get session_manager_google_ouath_callback_handler_url
    assert_response :success
  end
end
