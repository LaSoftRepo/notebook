require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'Authentication' do
    it "allows only unauthenticated users to log in" do
      expect(controller).to(
        filter(:before, with: :redirect_authenticated_user, only: [:new, :create])
      )
    end

    it "allows only authenticated users to log out" do
      expect(controller).to(
        filter(:before, with: :authenticate_user, only: [:destroy])
      )
    end
  end

  describe 'Actions' do
    context 'Logged in' do
      log_in

      describe 'DELETE #destroy' do
        it 'logout user from system' do
          delete :destroy
          expect(controller.current_user).to eq nil
        end

        it 'sets flash[:notice] message' do
          delete :destroy
          expect(flash[:notice]).to be_present
        end

        it 'redirects to root_path' do
          delete :destroy
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'Logged out' do
      log_out

      describe 'GET #new' do
        it "renders 'sessions/new' template" do
          get :new
          expect(response).to render_template('sessions/new')
        end

        it 'returns status 200' do
          get :new
          expect(response.status).to eq 200
        end
      end

      describe 'POST #create' do
        let(:user) do
          FactoryGirl.create(:user, password: '12345678', password_confirmation: '12345678')
        end

        context 'WITH VALID PARAMS' do
          let(:valid_params) do
            {
              log_in: {
                email: user.email,
                password: '12345678'
              }
            }
          end

          it 'authenticates user' do
            post :create, params: valid_params
            expect(controller.current_user).to eq user
          end

          it 'sets flash[:notice] message' do
            post :create, params: valid_params
            expect(flash[:notice]).to be_present
          end

          it 'redirects to notebooks_path' do
            post :create, params: valid_params
            expect(response).to redirect_to notebooks_path
          end
        end

        context 'WITH INVALID PARAMS' do
          let(:invalid_params) do
            {
              log_in: {
                email: user.email,
                password: 'wrong_password'
              }
            }
          end

          it 'does not authenticate user' do
            post :create, params: invalid_params
            expect(controller.current_user).to eq nil
          end

          it 'assigns error message to @error' do
            post :create, params: invalid_params
            expect(assigns(:error)).to be_present
          end

          it "renders 'sessions/new' template" do
            post :create, params: invalid_params
            expect(response).to render_template('sessions/new')
          end

          it 'returns status 422' do
            post :create, params: invalid_params
            expect(response.status).to eq 422
          end
        end
      end
    end
  end
end
