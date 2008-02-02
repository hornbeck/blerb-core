steps_for(:boxy) do
  
  start_of_boxy_step = "they should see "
  end_of_boxy_step = ""
  
  Then "#{start_of_boxy_step}$child within $parent" do |child, parent|
    child_elements = tag_filter_and_attributes(child)
    parent_elements = tag_filter_and_attributes(parent)
    
    @response.body.should have_tag(*parent_elements[0..2]) do
      with_tag(*child_elements[0..2])
    end
  end
  
  Then "#{start_of_boxy_step}$parent with $attribute" do |parent, attribute|
    tag, filter, attributes = tag_filter_and_attributes(parent)
    unused, unused, extra_attribute = tag_filter_and_attributes(attribute)
    attributes.merge(extra_attribute)
    
    @response.body.should have_tag(tag, filter, attributes)
  end
  
  Then "#{start_of_boxy_step}$parent containing $filter" do |parent, filter|
    tag, unused, attributes = tag_filter_and_attributes(parent)
    unused, filter, unused = tag_filter_and_attributes(filter)
    
    @response.body.should have_tag(tag, filter, attributes)
  end
  
  Then "#{start_of_boxy_step}$parent#{end_of_boxy_step}" do |parent|
    tag, filter, attributes = tag_filter_and_attributes(parent)
    
    @response.body.should have_tag(tag, filter, attributes)
  end
end