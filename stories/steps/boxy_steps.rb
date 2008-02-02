# Boxy Steps
#
# Boxy Steps is an attempt at a convention for creating story tests
# that check html output.  This should make it easy to test for the
# existence of elements in the DOM tree.
#
# Currently their are four types of checks:
#   for an element
#   for an element containing a string or regexp
#   for an element with an attribute
#   for an element within another element
#
# Instead of specifying the class or id explicitly, Boxy Steps follow
# a convention of using an article before the identifier value to signal
# either class or id.  'a' and 'an' for class, 'the' for id.
#
# For example, "a round div" will match <div class='round'>
# "the signup subtitle" will match <h2 id='signup'>
#
# Also, there is aliasing for elements, so that in the previous example,
# subtitle will be translated to h2
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
  
  #example:
  #Then they should see a hentry box
  Then "#{start_of_boxy_step}$parent#{end_of_boxy_step}" do |parent|
    tag, filter, attributes = tag_filter_and_attributes(parent)
    
    @response.body.should have_tag(tag, filter, attributes)
  end
end