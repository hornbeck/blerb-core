steps_for(:boxy) do
  
  start_of_boxy_step = "they should see"
  end_of_boxy_step = ""

  html_tags = [
    %w[                   link          a                         ],
    %w[                   box           div                       ],
    %w[                                 form                      ],
    %w[                   title         h1                        ],
    %w[                   subtitle      h2                        ],
    %w[                                 h3                        ],
    %w[                                 h4                        ],
    %w[                                 h5                        ],
    %w[                                 h6                        ],
    %w[                   image         img                       ],
    %w[                                 input                     ],
    %w[                                 label                     ],
    %w[                   paragraph     p                         ],
    %w[                                 strong                    ],
    ]

  article_map = {
    "the" => :id,
    "an"  => :class,
     "a"  => :class
   }
   
   Then "#{start_of_boxy_step} $parent with $attribute" do |parent, attribute|
     tag, filter, attributes = tag_filter_and_attributes(parent)
     attributes.merge(attributize(attribute))
     
     @response.body.should have_tag(tag, filter, attributes)
   end
   
   Then "#{start_of_boxy_step} ${parent} #{end_of_boxy_step}" do |parent|
    tag, filter, attributes = tag_filter_and_attributes(parent)
    
    @response.body.should have_tag(tag, filter, attributes)
   end
end