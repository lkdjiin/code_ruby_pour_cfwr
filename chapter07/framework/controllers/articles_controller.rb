class ArticlesController < BaseController
  def index
    @articles = Article.all
    render "articles/index.html.erb"
  end
end
