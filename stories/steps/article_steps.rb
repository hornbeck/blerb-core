steps_for(:article) do
  Given "there is an article" do
    #shouldn't have to do this here if the test environment is transactional
    Article.delete_all
    
    @article = Article.create :title        => "Blerbin",
                              :body         => "bloggin with blerb",
                              :created_at   => Time.now,
                              :updated_at   => Time.now,
                              :published_at => Time.now,
                              :draft        => "bloggin in blerb",
                              :slug         => "blerbin"
  end
  
  When "they view the article" do
    @response = get(url(:article, @article))
  end
end