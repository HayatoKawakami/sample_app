require "test_helper"

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "フォロー一覧ページが正常に表示されているか？" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "フォロワー一覧ページが正常に表示されているか？" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "フォローが正常に機能しているか？" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, params: { followed_id: @other.id}
    end
  end

  test "フォローが正常に機能しているか？(AJax)" do
    assert_difference "@user.following.count", 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id}
    end
  end

  test "アンフォローが正常に機能しているか？" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
      delete relationship_path(relationship)
    end
  end

  test "アンフォローが正常に機能しているか？(AJax)" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference "@user.following.count", -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
end
