class Comments < Application
  provides :js
  
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])
    @comment.request = request
    if @comment.save
      if @comment.approved?
        #flash[:notice] = "Thanks for the comment."
      else
        #flash[:error] = "Unfortunately this comment is considered spam by Akismet. " + 
        #            "It will show up once it has been approved by the administrator."
      end
    end
  end
end