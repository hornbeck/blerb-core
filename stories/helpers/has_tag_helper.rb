class HasTag
  
  @@identifier_map = {
    :id => "#",
    :class => "."
  }
  
  def initialize(*args)
    (@tag, @filter), @attributes = args_and_options(*args)
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
    
    not @document.search(selector()).empty?
  end
  
  def selector
    start = "//#{@tag}#{'#' if @attributes.has_key?(:id)}#{@attributes.delete(:id)}#{'.' if @attributes.has_key?(:class)}#{@attributes.delete(:class)}"
    @attributes.to_a.inject(start) do |select, (key, value)|
      select << "[@#{key}=\"#{value}\"]"
      select
    end
  end
end

def have_tag(*args)
  HasTag.new(*args)
end