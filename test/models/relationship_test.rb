require "test_helper"

class RelationshipTest < ActiveSupport::TestCase
  

  def setup
    @relationship = Relationship.new(followed_id: users(:archer).id, follower_id: users(:michael).id )
  end

  test "正常に生成できているか" do
    assert @relationship.valid?
  end

  test "followed_idがnilの時、正常に生成できない判定が出るか？" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end

  test "follower_idがnilの時、正常に生成できない判定が出るか？" do 
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end
end
