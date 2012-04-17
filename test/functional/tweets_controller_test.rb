require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  setup do
    @tweet = tweets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tweet" do
    assert_difference('Tweet.count') do
      post :create, tweet: { created_at: @tweet.created_at, favorited: @tweet.favorited, geo: @tweet.geo, hashtags: @tweet.hashtags, id_str: @tweet.id_str, in_reply_to_screen_name: @tweet.in_reply_to_screen_name, in_reply_to_status_id: @tweet.in_reply_to_status_id, in_reply_to_user_id: @tweet.in_reply_to_user_id, in_reply_to_user_id_str: @tweet.in_reply_to_user_id_str, retweet_count: @tweet.retweet_count, retweeted: @tweet.retweeted, source: @tweet.source, text: @tweet.text, truncated: @tweet.truncated, tweet_id: @tweet.tweet_id, user_mentions: @tweet.user_mentions }
    end

    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should show tweet" do
    get :show, id: @tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tweet
    assert_response :success
  end

  test "should update tweet" do
    put :update, id: @tweet, tweet: { created_at: @tweet.created_at, favorited: @tweet.favorited, geo: @tweet.geo, hashtags: @tweet.hashtags, id_str: @tweet.id_str, in_reply_to_screen_name: @tweet.in_reply_to_screen_name, in_reply_to_status_id: @tweet.in_reply_to_status_id, in_reply_to_user_id: @tweet.in_reply_to_user_id, in_reply_to_user_id_str: @tweet.in_reply_to_user_id_str, retweet_count: @tweet.retweet_count, retweeted: @tweet.retweeted, source: @tweet.source, text: @tweet.text, truncated: @tweet.truncated, tweet_id: @tweet.tweet_id, user_mentions: @tweet.user_mentions }
    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should destroy tweet" do
    assert_difference('Tweet.count', -1) do
      delete :destroy, id: @tweet
    end

    assert_redirected_to tweets_path
  end
end
