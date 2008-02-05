module Admin
  class Articles < Application
    self._layout = 'admin'
    provides :html, :js
    
    def index
      @articles = Article.all
      render @articles
    end
  
    def show(id)
      @article = Article[id]
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
        redirect url(:admin_article, @article)
      else
        render :action => :new
      end
    end
  
    def edit(id)
      only_provides :html
      @article = Article[id]
      raise NotFound unless @article
      render
    end
  
    def update(id, article)
      @article = Article[id]
      raise NotFound unless @article
      if @article.update_attributes(article)
        redirect url(:admin_article, @article)
      else
        raise BadRequest
      end
    end
  
    def destroy(id)
      @article = Article[id]
      raise NotFound unless @article
      if @article.destroy!
        redirect url(:admin_articles)
      else
        raise BadRequest
      end
    end
  end
end