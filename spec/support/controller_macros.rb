module ControllerMacros
  def log_in
    before do
      @user ||= FactoryGirl.create(:user)
      controller.instance_variable_set(:@current_user, @user)
    end
  end

  def log_out
    before do
      @user = nil
      controller.instance_variable_set(:@current_user, nil)
    end
  end

  # TODO: It would be nice to test a controller that it has the before_action
  # And there will not be a context like "LOGGED IN"
  def redirects_unauthenticated_user_to_login(method, action, params = {})
    it 'redirects to the login with the warning message' do
      case method
        when :get    then get    action, params: params
        when :post   then post   action, params: params
        when :put    then put    action, params: params
        when :patch  then patch  action, params: params
        when :delete then delete action, params: params
      end
      expect(flash[:warning]).to be_present
      expect(response).to redirect_to log_in_path
    end
  end
end
