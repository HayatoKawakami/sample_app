require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "新規登録失敗した場合、ユーザー数のカウントが増えない" do
    get signup_path
    assert_no_difference 'User.count' do 
      post users_path, params: { user: {
        name: "",
        email: "hayato.drsp@gmail.com",
        password: "h03220322",
        password_confirmation: "h03220322"
      }}
    end
    assert_template 'users/new'
  end

  test "新規会員登録完了→ログインした状態でプロフィール画面へ遷移する" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {
        name: "テスト太郎",
        email: "hayato.drsp@gmail.com",
        password: "h03220322",
        password_confirmation: "h03220322"
      }}
    end
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
