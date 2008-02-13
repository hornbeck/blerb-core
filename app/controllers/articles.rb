class Articles < Application
  provides :html, :atom

  def index
    @articles = Article.find(:all, :order => 'created_at desc')
    display @articles
  end

  def show(id)
    @article = Article.first :slug => id
    raise NotFound unless @article
    display @article
  end

end
