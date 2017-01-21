require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  context 'LOG IN' do
    log_in

    describe 'GET #new' do

      it "redirects to root path" do
        get :new

        expect(response).to redirect_to root_path
      end
    end
  end

  context 'LOG OUT' do
    log_out

    describe 'GET #new' do

      it "renders 'users/new' template" do
        get :new

        expect(response).to render_template('users/new')
      end
    end
  end
end
