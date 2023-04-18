require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get upload" do
    get users_upload_url
    assert_response :success
  end
end
