class PasswordResetService

  class PasswordResetExpired < StandardError; end

  def send_instructions(email)
    return false unless email.match User::VALID_EMAIL_REGEX
    user = User.find_by(email: email)
    if user
      user.password_reset_token = SecureRandom.uuid
      user.password_reset_sent_at = Time.zone.now
      user.save
      UserMailer.password_reset(user).deliver_now
    end

    true
  end

  def update_password(user, params)
    raise PasswordResetExpired if user.password_reset_sent_at < 1.hour.ago
    user.password_validation_is_required = true
    user.update_attributes(
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  end
end
