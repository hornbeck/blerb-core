class Articles < Application
  provides :html, :atom

  def index
    @articles = Article.all(:order => 'created_at desc')
    display @articles
  end

  def show(id)
    @article = Article.with_slug(id)
    raise NotFound unless @article
    display @article
  end

end
