class PostsController < BaseController
  def index
    @posts = Post.all
    render "posts/index.html.erb"
  end

  def show
    @post = Post[params["id"]]
    render "posts/show.html.erb"
  end

  def delete
    post = Post[params["id"]]
    post.delete
    redirect_to "/posts"
  end
end
