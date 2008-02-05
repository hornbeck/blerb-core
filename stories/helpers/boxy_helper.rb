module BoxyStories
  
  HTML_TAGS = [
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
    %w[                   page_title    title                     ],
    %w[                                 strong                    ],
    ]

  ARTICLE_MAP = {
    "the" => :id,
    "an"  => :class,
     "a"  => :class
   }

  TAG_MAP = HTML_TAGS.inject({}) {|h, a| h[a[0]] = a[1] if a[1]; h}
  TAGS = HTML_TAGS.flatten.sort_by{|t| -t.size}
  
  def tag_filter_and_attributes(string)
    parts = string.scan /(?:\"|\')(?:\w+| +)+(?:\"|\')|(?:\w|-)+/
    
    case parts.size
    when 1
      return nil, as_filter(parts[0]), {} if is_filter?(parts[0])
      return TAG_MAP[parts[0]] || parts[0], nil, {}
    when 2
      return nil, nil, {parts[1].to_sym => as_attribute(parts[0])} if is_attribute?(parts[0])
      return TAG_MAP[parts[1]] || parts[1], (as_filter(parts[0]) if is_attribute?(parts[0])), {}
    when 3
      return nil, nil, { parts[2].to_sym => as_attribute(parts[1]) } if is_attribute?(parts[1])
      return TAG_MAP[parts[2]] || parts[2], nil, ARTICLE_MAP[parts[0]] => parts[1]
    else
      raise "invalid boxy step portion: #{string}"
    end
  end
  
  def as_filter(part)
    case part
    when /^\'.*\'$/
      Regexp.compile(part.to_s[1..-2])
    when /^\".*\"$/
      part.to_s[1..-2]
    end
  end
  
  alias_method :as_attribute, :as_filter
  
  def is_filter?(part)
    part =~ /^\'.*\'$/ || part =~ /^\".*\"$/
  end
  
  alias_method :is_attribute?, :is_filter?
end