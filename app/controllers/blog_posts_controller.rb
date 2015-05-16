class BlogPostsController < ApplicationController
  layout 'home'

  def index
    @blog_post = BlogPost.last
    @all_blog_posts = BlogPost.all.order('created_at desc')
    if @blog_post
      @image_url = @blog_post.image_url || ''
    end
  end

  def show
    @blog_post = BlogPost.find(params[:id])
    @all_blog_posts = BlogPost.all.order('created_at desc')
    if @blog_post
      @image_url = @blog_post.image_url || ''
    end
  end

  def tags
    @all_blog_posts = BlogPost.all.select{|blog_post| blog_post.tags.split(',').map(&:strip).include?(params[:id])}
    @blog_post = (@all_blog_posts.sort_by{ |blog| blog.created_at}).first
    if @blog_post
      @image_url = @blog_post.image_url || ''
    end
  end
end
