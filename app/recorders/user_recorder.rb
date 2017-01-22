class UserRecorder

  def initialize(user)
    @user = user
  end

  def create(params)
    user = User.new(params)
    user.password_validation_is_required = true
    user.save
    user
  end

  def update(params)
    # TODO update method in UserRecorder
    # @user...
  end
end
