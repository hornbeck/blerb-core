dependency "app/controllers/application"
module Admin
  class Articles < Application
    self._layout = 'admin'
    provides :html, :js

    def index
      @articles = Article.all
      display @articles
    end

    def show(id)
      @article = Article.with_slug(id)
      raise NotFound unless @article
      display @article
    end

    def new
      only_provides :html
      @article = Article.new
      display @article
    end

    def create(article)
      @article = Article.new(article)
      if @article.save
        redirect url(:admin_home)
      else
        render :new
      end
    end

    def edit(id)
      only_provides :html
      @article = Article.with_slug(id)
      raise NotFound unless @article
      render
    end

    def update(id, article)
      @article = Article.with_slug(id)
      raise NotFound unless @article
      if @article.update_attributes(article)
        redirect url(:admin_home)
      else
        raise BadRequest
      end
    end

    def destroy(id)
      @article = Article.with_slug(id)
      raise NotFound unless @article
      if @article.destroy!
        redirect url(:admin_home)
      else
        raise BadRequest
      end
    end
  end
end
