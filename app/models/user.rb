require 'digest/sha1'
dependency 'authenticated_system_model'
class User < DataMapper::Base
  include AuthenticatedSystem::Model
  
  attr_accessor :password, :password_confirmation
  
  property :email,                      :string
  property :crypted_password,           :string
  property :salt,                       :string
  property :activation_code,            :string
  property :activated_at,               :datetime
  property :remember_token_expires_at,  :datetime
  property :remember_token,             :string
  property :created_at,                 :datetime
  property :updated_at,                 :datetime
  property :first_name,                 :string
  property :last_name,                  :string
  
  validates_presence_of       :email
  # validates_format_of         :email,                   :as => :email_address
  validates_length_of         :email,                   :within => 3..100
  validates_uniqueness_of     :email
  validates_presence_of       :password,                :if => proc {password_required?}
  validates_presence_of       :password_confirmation,   :if => proc {password_required?}
  validates_length_of         :password,                :within => 4..40, :if => proc {password_required?}
  validates_confirmation_of   :password,                :groups => :create
    
  before_save :encrypt_password
  before_create :make_activation_code
  after_create :send_signup_notification
  
  def email=(value)
    @email = value.downcase unless value.nil?
  end

  EMAIL_FROM = "info@mysite.com"
  SIGNUP_MAIL_SUBJECT = "Welcome to MYSITE.  Please activate your account."
  ACTIVATE_MAIL_SUBJECT = "Welcome to MYSITE"
  
  # Activates the user in the database
  def activate
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save

    # send mail for activation
    UserMailer.dispatch_and_deliver(  :activation_notification,
                                  {   :from => User::EMAIL_FROM,
                                      :to   => self.email,
                                      :subject => User::ACTIVATE_MAIL_SUBJECT },

                                      :user => self )

  end
  
  def send_signup_notification
    UserMailer.dispatch_and_deliver(
        :signup_notification,
      { :from => User::EMAIL_FROM,
        :to  => self.email,
        :subject => User::SIGNUP_MAIL_SUBJECT },
        :user => self        
    )
  end

end