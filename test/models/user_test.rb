require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "河上勇人", email: "hayato.drsp@gmail.com", password: "h03220322", password_confirmation: "h03220322")
  end

  test "should be valid?" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid address" do 
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do 
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do 
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "パスワードが空欄である場合、アカウントは無効である" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "パスワードが6文字以下だった場合、アカウントは無効である" do 
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "remember_digestが存在しなかった場合のauthenticated?のテスト" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "ユーザーが削除された時、そのユーザーの投稿も同時に削除されているか？" do
    @user.save
    @user.microposts.create!(content: "これはテスト投稿です")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "フォロー機能とアンフォロー機能が正常か？" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "フィードに自分の投稿とfollowingのアカウントの投稿が表示されているか？" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)

    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    michael.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end

    archer.microposts.each do |post_following|
      assert_not michael.feed.include?(post_following)
    end
  end
end
