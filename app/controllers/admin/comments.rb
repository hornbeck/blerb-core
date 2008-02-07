module Admin
  class Comments < Application
    self._layout = 'admin'
  
    def index
      @comments = Comment.ham
      @spams = Comment.spam
      display @comments
    end
  
    def show(id)
      @comment = Comment[id]
      raise NotFound unless @comment
      display @comment
    end
  
    def edit(id)
      only_provides :html
      @comment = Comment[id]
      raise NotFound unless @comment
      render
    end
  
    def update(id, comment)
      @comment = Comment[id]
      raise NotFound unless @comment
      if @comment.update_attributes(comment)
        redirect url(:comment, @comment)
      else
        raise BadRequest
      end
    end
    
    def approve(id)
      @comment = Comment.find(params[:id])
      @comment.mark_as_ham!
      redirect url(:admin_comments)
    end

    def reject(id)
      @comment = Comment[id]
      @comment.mark_as_spam!
      redirect url(:admin_comments)
    end
    
    def destroy_multiple(comment_ids)
      Comment[comment_ids].destroy
      redirect url(:admin_comments)
    end
    
    def destroy(id)
      @comment = Comment[id]
      raise NotFound unless @comment
      if @comment.destroy!
        redirect url(:comments)
      else
        raise BadRequest
      end
    end
  end
end