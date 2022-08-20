require "test_helper"

class MicropostTest < ActiveSupport::TestCase
  


  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: "これはテスト投稿です")
  end

  test "投稿は正常か？" do
    assert @micropost.valid?
  end

  test "user_idが空の場合、投稿は正常でないか？" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "contentがからの場合」、投稿は正常でないか？" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "contentが140字以上の場合、投稿は正常でないか？" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "most_recentは初めての投稿か？" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  
end
