require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
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
      let(:params) do
        user = FactoryGirl.create(:user, password: 'password', password_confirmation: 'password')
        { user: { email: user.email, password: 'password' } }
      end

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

    describe 'DELETE #destroy' do
      it 'logout user' do
        delete :destroy
        expect(controller.current_user).to eq nil
      end

      it 'sets flash[:notice] message' do
        delete :destroy
        expect(flash[:notice]).to be_present
      end

      it 'redirects to root path' do
        delete :destroy
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        delete :destroy
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

    describe 'DELETE #destroy' do

    end
  end
end
