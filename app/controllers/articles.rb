class Articles < Application
  provides :xml, :js, :yaml
  
  def index
    @articles = Article.find(:all, :order => 'created_at desc')
    render @articles
  end
  
  def show(id)
    @article = Article.find(id)
    raise NotFound unless @article
    render @article
  end
  
  def new
    only_provides :html
    @article = Article.new
    render @article
  end
  
  def create(article)
    @article = Article.new(article)
    if @article.save
      redirect url(:article, @article)
    else
      render :action => :new
    end
  end
  
  def edit(id)
    only_provides :html
    @article = Article.find(id)
    raise NotFound unless @article
    render
  end
  
  def update(id, article)
    @article = Article.find(id)
    raise NotFound unless @article
    if @article.update_attributes(article)
      redirect url(:article, @article)
    else
      raise BadRequest
    end
  end
  
  def destroy(id)
    @article = Article.find(id)
    raise NotFound unless @article
    if @article.destroy!
      redirect url(:articles)
    else
      raise BadRequest
    end
  end
end