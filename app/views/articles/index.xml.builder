xml.instruct!
xml.feed :xmlns => "http://www.w3.org/2005/Atom" do |feed|
  feed.title(current_settings.title)
  feed.subtitle(current_settings.tagline)
  feed.link :href => url(:home)
  feel.link :href => url(:home,:format => :atom)
  feed.updated(@articles.first.published_at)
  for article in @articles
    feed.entry(post) do |entry|
      entry.title(article.title)
      entry.link :href=>"#{url(:article,article)}"
      entry.updated(article.published_at)
      entry.content(article.body, :type => 'html')
    end
  end
end