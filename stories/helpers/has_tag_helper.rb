class HasTag
  
  @@identifier_map = {
    :id => "#",
    :class => "."
  }
  
  def initialize(tag, filter = nil, attributes = {})
    @tag = tag
    @filter = filter
    @attributes = attributes
  end
  
  def matches?(stringlike)
    @document = case stringlike
    when Hpricot::Elem
      stringlike
    when StringIO
      Hpricot.parse(stringlike.string)
    else
      Hpricot.parse(stringlike)
    end
  end
end