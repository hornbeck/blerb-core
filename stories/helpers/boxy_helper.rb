module BoxyStories
  module InstanceMethods
    
    def method_missing_with_boxy_check(sig, *args, &block)
      case check_type(name = sig.id2name)
      when :have
        have_check(name, *args, &block)
      when :with
        with_check(name, *args, &block)
      when :multi_have
        multi_check(name, *args, &block)
      when :have_with
        have_with_check(name, *args, &block)
      when :have_with_content
        have_with_content_check(name, *args, &block)
      end
    end
  
    def check_type(sig)
      case sig
      when /^have_(an?|the)\w+_in_\w+/, /^has_(an?|the)\w+_in_\w+\?$/
        :multi_have
      when /^have_(an?|the)\w+_with_content/, /^has_(an?|the)\w+_with_content\?$/
        :have_with_content
      when /^have_(an?|the)\w+_with_\w+/, /^has_(an?|the)\w+_with_\w+\?$/
        :have_with
      when /^have_(an?|the)/, /^has_(an?|the)\w+\?$/
        :have
      when /^with_(an?|the)/
        :with
      end
    end
  
    def have_check(sig, *args, &block)
      identifier, element = identifier_and_element(sig)
      i_value = *args.first
      
      identifier = nil if i_value.nil?
      
      raise "html element missing from the response: <#{element} #{identifier == '.' ? 'class' : 'id' if identifier}=\"#{i_value}\">\n\n#{@response.body}" unless match_selector("//#{element}#{identifier}#{i_value}").matches?(@response.body)
      true
    end
    
    alias_method :with_check, :have_check
    
    def have_with_check(sig, *args, &block)
      element, identifier, attribute = split_have_with_signature(sig)
      i_value, a_value = args[0..1]
      
      identifier = nil if i_value.nil?
      
      raise "html element missing from the response: <#{element} #{identifier == '.' ? 'class' : 'id'}=\"#{i_value}\" #{attribute}=\"#{a_value}\">\n\n#{@response.body}" unless match_selector("//#{element}#{identifier}#{i_value}[@#{attribute}=\"#{a_value}\"]").matches?(@response.body)
      true
    end
    
    def have_with_content_check(sig, *args, &block)
      identifier, element = identifier_and_element(sig)
      i_value, c_value = args[0..1]
      
      identifier = nil if i_value.nil?
      
      #Not working, not sure why...
      #case c_value
      #when Regexp
      #  raise "html tag <#{element} #{identifier == '.' ? 'class' : 'id'}=\"#{i_value}\"> did not pass the filter: /#{c_value.inspect[1..-2]}/\n\n#{@response.body}" unless  match_selector("//#{element}#{identifier}#{i_value}[@text()~=\"#{c_value.inspect[1..-2]}\"]").matches?(@response.body)
      #when String
      #  raise "html tag <#{element} #{identifier == '.' ? 'class' : 'id'}=\"#{i_value}\"> did not contain the string: \"#{c_value}\"\n\n#{@response.body}" unless match_selector("//#{element}#{identifier}#{i_value}[@text()*=\"#{c_value}\"]").matches?(@response.body)
      #end
      
      document = case @response.body
        when Hpricot::Elem
          @response.body
        when StringIO
          Hpricot.parse(@response.body.string)
        else
          Hpricot.parse(@response.body)
        end
      
      expected = "//#{element}#{identifier}#{i_value}"
      
      case c_value
      when Regexp
        raise "html tag <#{element} #{identifier == '.' ? 'class' : 'id'}=\"#{i_value}\"> did not pass the filter: /#{c_value.inspect[1..-2]}/\n\n#{@response.body}" if document.search(expected).select { |ele| ele.inner_text =~ c_value }.empty?
      when String
        raise "html tag <#{element} #{identifier == '.' ? 'class' : 'id'}=\"#{i_value}\"> did not contain the string: \"#{c_value}\"\n\n#{@response.body}" if document.search(expected).select { |ele| ele.inner_text.include? c_value }.empty?
      end
      
      true
    end
    
    def multi_check(sig, *args, &block)
      child, parent = split_multi_sig(sig)
      
      c_identifier, c_element = identifier_and_element(child)
      p_identifier, p_element = identifier_and_element(parent)
      
      c_value = args.shift
      p_value = args.shift
      
      c_identifier = nil if c_value.nil?
      p_identifier = nil if p_value.nil?
      
      raise "html tag <#{c_element} #{c_identifier == '.' ? 'class' : 'id' if c_identifier}=\"#{c_value}\"> is not nested within a <#{p_element} #{p_identifier == '.' ? 'class' : 'id' if p_identifier}=\"#{p_value}\"> tag:\n\n#{@response.body}" unless match_selector("//#{p_element}#{p_identifier}#{p_value}//#{c_element}#{c_identifier}#{c_value}").matches?(@response.body)
      
      true
    end
    
    def split_have_with_signature(sig)
      element_and_identifier, attribute = sig.split("_with_")
      char, element = identifier_and_element(element_and_identifier)
      return [element, char, attribute].collect {|node| html_lookup(node)}
    end
    
    def split_multi_sig(sig)
      sig.split("_in_")
    end
  
    def attribute_element(sig)
      sig.split("_with_").last
    end
    
    def identifier_and_element(sig)
      if match = sig.scan(/(?:have_)?(an?|the)_([a-zA-Z0-9]+)/).first
        case match.first
        when "a", "an"
          return ".", html_lookup(match[1])
        when "the"
          return "#", html_lookup(match[1])
        end
      end
    end
  
    def html_lookup(key)
      elements = {
        "box"       => "div",
        "title"     => "h1",
        "subtitle"  => "h2",
        "paragraph" => "p",
        "link"      => "a",
        "image"     => "img",
        "source"    => "src",
        "path"      => "href"
      }
    
      elements.default = key
    
      elements[key]
    end
    
    def method_missing_with_boxy_helper(meth, *args, &block)
      p meth.id2name
      if check_type(meth.id2name)
        method_missing_with_boxy_check(meth, *args, &block)
      else
        method_missing_without_boxy_helper(meth, *args, &block)
      end
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.alias_method_chain :method_missing, :boxy_helper
  end
end