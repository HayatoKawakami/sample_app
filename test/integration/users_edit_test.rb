require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "ユーザー情報の更新に失敗するテスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "", email: "hayato.drsp@gmail.com", password: "h03220322", password_confirmation: "h03220322"}}
    assert_template "users/edit"
  end

  test "ユーザー情報の更新に成功するテスト" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: "Tom", email: "hayato.drsp@gmail.com", password: "", password_confirmation: ""}}
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal "Tom", @user.name
  end

  test "未ログイン時にeditページにはアクセスできず、そのままログイン。editページに自動遷移し、ユーザー情報の更新に成功するテスト" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    patch user_path(@user), params: { user: { name: "Tom", email: "hayato.drsp@gmail.com", password: "", password_confirmation: ""}}
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_equal "Tom", @user.name
  end

  test "別ユーザーでログイン中@userのeditページに遷移しようとすると、Flashで注意されトップページに飛ばされる" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "別ユーザーでログイン中@userのupdateしようとすると、Flashで注意されトップページに飛ばされる" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: "John", email: "hayato.drsp@gmail.com", password: "h03220322", password_confirmation: "h03220322"}}
    assert_not flash.empty?
    assert_redirected_to root_url
  end

  test "ログインしないままeditページに遷移しようとすると、Flashで注意されログインページに飛ばされる" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "ログインしないままupdateしようとすると、Flashで注意されログインページに飛ばされる" do
    patch user_path(@user), params: { user: { name: "John", email: "hayato.drsp@gmail.com", password: "h03220322", password_confirmation: "h03220322"}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
end
