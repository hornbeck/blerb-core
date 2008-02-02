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
    parts = string.scan /(?:\"|\')(?:\w+| +)+(?:\"|\')|\w+/
    
    case parts.size
    when 3
      return TAG_MAP[parts[2]] || parts[2], as_filter(parts[1]), {} if is_filter?(parts[1])
      return TAG_MAP[parts[2]] || parts[2], nil, ARTICLE_MAP[parts[0]] => parts[1]
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
  
  def is_filter?(part)
    part =~ /^\'.*\'$/ || part =~ /^\".*\"$/
  end
end