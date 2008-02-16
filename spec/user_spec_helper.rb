module UserSpecHelper
  def valid_user_hash
    { :email                  => 'daniel@example.com',
      :password               => 'sekret',
      :password_confirmation  => 'sekret',
      :first_name             => 'John',
      :last_name              => 'Doe'}
  end
end