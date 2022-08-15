class UsersControllerTest < ActionDispatch::IntegrationTest
  require "test_helper"

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  test "ログインしていなかった場合、ユーザー一覧のアクセスは弾かれ、ログイン画面に飛ばされる" do 
    get users_path
    assert_redirected_to login_url
  end

  test "アカウント削除を試みるも、ログインをしていないので、ログインにはじかれてログインを求められる。" do
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "アカウント削除を試みるも、管理者権限なしなので、トップ画面に弾かれる" do 
    log_in_as(@other_user)
    assert_no_difference "User.count" do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  
end
