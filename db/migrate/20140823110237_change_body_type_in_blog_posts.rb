class ChangeBodyTypeInBlogPosts < ActiveRecord::Migration
  def up
    change_column :blog_posts, :body, :text
  end

  def down
    change_column :blog_posts, :body, :string
  end
end
