steps_for(:article) do
  Given "there is an article" do
    #shouldn't have to do this here if the test environment is transactional
    Article.delete_all
    
    @article = Article.create(:title => "Blerbin")
  end
  
  When "they view the article" do
    @response = get(url(:article, @article)).first
  end
end