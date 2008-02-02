class HasTag
  
  @@identifier_map = {
    :id => "#",
    :class => "."
  }
  
  def initialize(*args)
    (@tag, @filter), @attributes = args_and_options(*args)
  end
  
  def matches?(stringlike, &block)
    @document = case stringlike
    when Hpricot::Elem
      stringlike
    when StringIO
      Hpricot.parse(stringlike.string)
    else
      Hpricot.parse(stringlike)
    end
    
    not @document.search(selector(&block)).empty?
  end
  
  def selector(&block)
    
    start = "//#{@tag}#{'#' if @attributes.has_key?(:id)}#{@attributes.delete(:id)}#{'.' if @attributes.has_key?(:class)}#{@attributes.delete(:class)}"
    @selector = @attributes.to_a.inject(start) do |select, (key, value)|
      select << "[@#{key}=\"#{value}\"]"
      select
    end
    
    @selector << @inner_has_tag.selector if (@inner_has_tag = block.call).is_a?(HasTag) unless block.nil?
    
    @selector
  end
end

def have_tag(*args)
  HasTag.new(*args)
end

alias :with_tag :have_tag