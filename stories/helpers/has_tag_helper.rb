class HasTag
  def initialize(*args)
    (@tag, @filter), @attributes = args_and_options(*args)
    @id, @class = @attributes.delete(:id), @attributes.delete(:class)
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
    
    not case @filter
    when Regexp
      @document.search(selector(&block)).select{|ele| ele.inner_text =~ @filter}.empty?
    when String
      @document.search(selector(&block)).select{|ele| ele.inner_text.include?(@filter)}.empty?
    else
      @document.search(selector(&block)).empty?
    end
  end
  
  def selector(&block)
    start = "//#{@tag}#{"##{@id}" if @id}#{".#{@class}" if @class}"
    @selector = @attributes.to_a.inject(start) do |select, (key, value)|
      select << "[@#{key}=\"#{value}\"]"
      select
    end
    
    @selector << @inner_has_tag.selector if (@inner_has_tag = block.call).is_a?(HasTag) unless block.nil?
    
    @selector
  end
  
  def failure_message
    "expected following output to contain a #{tag_for_error} tag:\n#{@document}"
  end
  
  def negative_failure_message
    "expected following output to omit a #{tag_for_error} tag:\n#{@document}"
  end
  
  def inner_failure_message
    "#{@inner_has_tag.tag_for_error} tag within a " unless @inner_has_tag.nil?
  end
  
  def tag_for_error
    "#{inner_failure_message}<#{@tag}#{id_for_error}#{class_for_error}#{attributes_for_error}>#{filter_for_error}"
  end
  
  def id_for_error
    " id=\"#{@id}\"" unless @id.nil?
  end
  
  def class_for_error
    " class=\"#{@class}\"" unless @class.nil?
  end
  
  def attributes_for_error
    @attributes.to_a.inject("") do |s, (key, pair)|
      s << " #{key}=\"#{pair}\""; s
    end
  end
  
  def filter_for_error
    case @filter
    when String
      "#{@filter}</#{@tag}>"
    when Regexp
      "#{@filter.inspect}/</#{@tag}"
    end
  end
  
  def with_tag(*args)
    @inner_has_tag = HasTag.new(*args)
  end
end

# rspec matcher to test for the presence of tags
# ==== Examples
# body.should have_tag("div")
# => #checks for <div>
#
# body.should have_tag("span", :id => :notice)
# => #checks for <span id="notice">
#
# body.should have_tag(:h2, :class => "bar", :id => "foo")
# => #checks for <h1 id="foo" class="bar">
#
# body.should have_tag(:div, :attr => :val)
# => #checks for <div attr="val">
#
# body.should have_tag(:h1, "Title String")
# => #checks for <h1>Title String</h1>
#
# body.should have_tag(:h2, /subtitle/)
# => #checks for <h2>/subtitle/</h2>
def have_tag(*args)
  HasTag.new(*args)
end

alias :with_tag :have_tag
def have_tag(*args)
  HasTag.new(*args)
end

alias :with_tag :have_tag