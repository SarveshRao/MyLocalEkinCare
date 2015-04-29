class Staff::BlogPostsController < StaffController
  before_action :staff_authenticated,:blog_posts_active
  layout 'staff'

  def index
    @blog_posts = BlogPost.all
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post =  BlogPost.new(blog_post_params)

    if @blog_post.save!
      redirect_to staff_blog_posts_path, notice: 'Your post is created Successfully'
    else
      redirect_to new_staff_blog_post_path, notice: 'Sorry! Problem creating a blog post'
    end
  end

  def edit
    @blog_post = BlogPost.find(params[:id])
  end

  def update
    @blog_post = BlogPost.find(params[:id])
    @blog_post.update(blog_post_params)
    if @blog_post.save
      redirect_to staff_blog_posts_path, notice: 'Your Post is successfully updated'
    else
      render :edit
    end
  end

  def blog_posts_active
    @blog_posts_active = true
  end

  private
  def blog_post_params
    params.require(:blog_post).permit(:title, :author, :tags, :body, :image)
  end
end
