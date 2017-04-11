class PostsController < BaseController
  def index
    @posts = Post.all
    render "posts/index.html.erb"
  end

  def show
    if (@post = Post[params["id"]])
      render "posts/show.html.erb"
    else
      error_404
    end
  end

  def delete
    post = Post[params["id"]]
    post.delete
    redirect_to "/posts"
  end

  def new
    @post = Post.new
    render "posts/new.html.erb"
  end

  def create
    Post.create(title: params["title"],
                content: params["content"],
                date: Time.now.to_i)
    notice("Post créé avec succès")
    redirect_to "/posts"
  end

  def edit
    @post = Post[params["id"]]
    render "posts/edit.html.erb"
  end

  def update
    post = Post[params["id"]]
    post.update(title: params["title"], content: params["content"])
    redirect_to "/posts"
  end
end
