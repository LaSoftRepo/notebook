module SessionsHelper

  def log_in(user, permanent = false)
    auth_token = TokenGenerator.generate
    if permanent
      cookies.permanent[:auth_token] = auth_token
    else
      cookies[:auth_token] = auth_token
    end
    user.update_attribute(:auth_token, Encryptor.encrypt(auth_token))
    @current_user = user
  end

  def log_out
    current_user.generate_auth_token
    current_user.save
    cookies.delete(:auth_token)
    @current_user = nil
  end

  def current_user
    return @current_user if @current_user

    if cookies[:auth_token]
      auth_token = Encryptor.encrypt(cookies[:auth_token])
      @current_user = User.where(auth_token: auth_token).first
    else
      nil
    end
  end
end
