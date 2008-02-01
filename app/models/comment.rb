dependency 'akismetor'
class Comment < DataMapper::Base
  property :body,       :text
  property :email,      :string
  property :name,       :string
  property :url,        :string
  property :created_at, :datetime
  property :user_ip,    :string
  property :user_agent, :string
  property :referrer,   :string
  property :approved,   :boolean,  :default => true
  
  belongs_to :article
  
  validates_presence_of :name, :body, :email
  
  attr_writer :spam, :ham, :current_user
  
  def self.spam
    all(:approved => false, :order => 'created_at DESC') 
  end
  
  def self.ham
    all(:approved => true, :order => 'created_at DESC')
  end

  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end

  def akismet_attributes
    {
      :key                  => 'API_KEY',
      :blog                 => 'YOURBLOG_URL',
      :user_ip              => user_ip,
      :user_agent           => user_agent,
      :comment_author       => name,
      :comment_author_email => email,
      :comment_author_url   => url,
      :comment_content      => body
    }
  end

  def mark_as_spam!
    update_attribute(:approved, false)
    Akismetor.submit_spam(akismet_attributes)
  end

  def mark_as_ham!
    update_attribute(:approved, true)
    Akismetor.submit_ham(akismet_attributes)
  end
  
  protected
    def check_for_spam
      self.approved = !Akismetor.spam?(akismet_attributes)
      true # return true so it doesn't stop save
    end
end