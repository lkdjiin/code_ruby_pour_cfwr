class ArticlesController < BaseController
  def index
    articles = Article.all

    puts "-----------------------------------------------"
    p articles
    puts "-----------------------------------------------"
  end
end
