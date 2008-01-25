class Articles < Application
  
  def index
    @articles = Article.all
    render
  end

  def show
    @article = Article.find params[:id]
    render
  end

end