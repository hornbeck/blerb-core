steps_for(:boxy) do
  html_elements = %w[paragraph subtitle strong image input label title form link box div img h1 h2 h3 h4 h5 h6 a p]
  
  [%w[' "], %w[" '], [nil, nil]].each do |containers|
    When "they go to #{containers.first}$url#{containers.first}" do |url|
      get url
    end
    
    Then "they should see the #{containers.first}$template#{containers.first} template" do |template|
      response.should render_template(template)
    end
    
    html_elements.each do |parent_element|
      %w[a an the].each do |first_article|

        html_elements.each do |child_element|
          %w[a an the].each do |second_article|
            Then "they should see #{first_article} #{containers.first}$child#{containers.first} #{child_element} within #{second_article} #{containers.last}$parent#{containers.last} #{parent_element}" do |child, parent|
              multi_check("have_#{first_article}_#{child_element}_in_#{second_article}_#{parent_element}", child, parent)
            end
            
            Then "they should see #{first_article} #{containers.first}#{child_element}#{containers.first} within #{second_article} #{containers.last}$parent#{containers.last} #{parent_element}" do |parent|
              multi_check("have_#{first_article}_#{child_element}_in_#{second_article}_#{parent_element}", nil, parent)
            end
            
            Then "they should see #{first_article} #{containers.first}$child#{containers.first} #{child_element} within #{second_article} #{parent_element}" do |child|
              multi_check("have_#{first_article}_#{child_element}_in_#{second_article}_#{parent_element}", child)
            end
            
            Then "they should see #{first_article} #{containers.first}$parent#{containers.first} #{parent_element} with #{second_article} #{containers.last}$value#{containers.last} $attribute" do |parent, value, attribute|
              have_with_check("have#{first_article}_#{parent_element}_with_#{attribute}", parent, value)
            end
            
            Then "they should see #{first_article} #{parent_element} with #{second_article} #{containers.first}$value#{containers.first} $attribute" do |value, attribute|
              have_with_check("have#{first_article}_#{parent_element}_with_#{attribute}", nil, value)
            end
          end
        end
        
        Then "they should see #{first_article} #{parent_element} containing #{containers.first}$string#{containers.first}" do |string|
          have_with_content_check("have_#{first_article}_#{parent_element}_with_content", nil, string)
        end unless containers.first.nil?
        
        Then "they should see #{first_article} #{parent_element}" do
          have_check("have_#{first_article}_#{parent_element}")
        end
        
        Then "they should see #{first_article} #{containers.first}$parent#{containers.first} #{parent_element}" do |parent|
          have_check("have_#{first_article}_#{parent_element}", parent)
        end
        
        Then "they should see #{first_article} #{containers.first}#{parent_element}#{containers.first}" do
          have_check("have_#{first_article}_#{parent_element}")
        end
      end
    end
  end
end