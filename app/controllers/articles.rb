class Articles < Application
  provides :html, :atom
  
  def index
    @articles = Article.find(:all, :order => 'created_at desc')
    render @articles
  end
  
  def show(id)
    @article = Article.find(id)
    raise NotFound unless @article
    render @article
  end
end