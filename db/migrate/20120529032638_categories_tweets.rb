class CategoriesTweets < ActiveRecord::Migration
  def up
    create_table :categories_tweets, :id => false do |t|
      t.integer :category_id
      t.integer :tweet_id
  end
end

def down
    drop_table :categories_tweets
end
end
