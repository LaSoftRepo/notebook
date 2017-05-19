module ControllerMacros
  module Klass
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
  end

  module Instance
    def current_user
      controller.current_user
    end
  end
end
