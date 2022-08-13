class UsersControllerTest < ActionDispatch::IntegrationTest
  require "test_helper"

  test "should get new" do
    get signup_path
    assert_response :success
  end
  
end
