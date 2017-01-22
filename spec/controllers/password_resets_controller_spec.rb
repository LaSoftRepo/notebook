require 'rails_helper'

def set_password_reset_token(user, token)
  user.password_reset_token = token
  user.password_reset_sent_at = Time.zone.now
  user.save
end

RSpec.describe PasswordResetsController, type: :controller do
  let(:token) { 'token' }

  context 'LOGGED IN' do
    log_in

    describe 'GET #new' do
      it 'sets flash[:warning] message' do
        get :new
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        get :new
        expect(response.status).to eq 302
      end
    end

    describe 'POST #create' do
      let(:params) { { password_reset: { email: 'email@example.com' } } }
      before { FactoryGirl.create(:user, email: params[:password_reset][:email]) }

      it 'sets flash[:warning] message' do
        post :create, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        post :create, params: params
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        post :create, params: params
        expect(response.status).to eq 302
      end
    end

    describe 'GET #edit' do
      let(:params) { { id: token } }
      before { set_password_reset_token(controller.current_user, token) }

      it 'sets flash[:warning] message' do
        get :edit, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        get :edit, params: params
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        get :edit, params: params
        expect(response.status).to eq 302
      end
    end

    describe 'PATCH #update' do
      let(:params) do
        {
          id: token,
          user: { password: '123456', password_confirmation: '123456' }
        }
      end
      before { set_password_reset_token(controller.current_user, token) }

      it 'sets flash[:warning] message' do
        patch :update, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        patch :update, params: params
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        patch :update, params: params
        expect(response.status).to eq 302
      end
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #new' do

    end

    describe 'POST #create' do

    end

    describe 'GET #edit' do

    end

    describe 'PATCH #update' do

    end
  end
end
