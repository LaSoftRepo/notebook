require 'rails_helper'

def set_password_reset_token(user, token)
  user.password_reset_token = token
  user.password_reset_sent_at = Time.zone.now
  user.save
end

RSpec.describe PasswordResetsController, type: :controller do
  let(:token) { 'token' }

  describe 'AUTHENTICATION' do
    it "allows only unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :redirect_authenticated_user)
    end
  end

  describe 'ACTIONS' do
    log_out

    describe 'GET #new' do
      it "renders 'password_reset/new' template with status 200" do
        get :new
        expect(response).to render_template('password_resets/new')
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          user = FactoryGirl.create(:user, email: 'valid_email@example.com')
          { password_reset: { email: user.email } }
        end

        it 'calls send_instructions method of PasswordResetService' do
          expect_any_instance_of(PasswordResetService).to receive(:send_instructions) { true }
          post :create, params: valid_params
        end

        it 'sets flash[:notice] message' do
          post :create, params: valid_params
          expect(flash[:notice]).to be_present
        end

        it 'redirects to root' do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) { { password_reset: { email: 'invalid_email@example' } } }

        it 'calls send_instructions method of PasswordResetService' do
          expect_any_instance_of(PasswordResetService).to receive(:send_instructions) { false }
          post :create, params: invalid_params
        end

        it 'assigns error message to @error' do
          post :create, params: invalid_params
          expect(assigns(:error)).to be_present
        end

        it "renders 'password_resets/new' template with status 422" do
          post :create, params: invalid_params
          expect(response).to render_template('password_resets/new')
          expect(response.status).to eq 422
        end
      end
    end

    describe 'GET #edit' do
      context 'TOKEN DOES NOT EXIST' do
        let(:params) { { id: 'not_existing_token' } }

        it 'raises an error' do
          expect do
            get :edit, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end

      context 'TOKEN EXISTS' do
        let(:params) { { id: token } }
        let(:user) { FactoryGirl.create(:user) }
        before { set_password_reset_token(user, params[:id]) }

        it "renders 'password_resets/edit' template with status 200" do
          get :edit, params: params
          expect(response).to render_template('password_resets/edit')
          expect(response.status).to eq 200
        end
      end
    end

    describe 'PATCH #update' do
      context 'TOKEN DOES NOT EXIST' do
        let(:params) do
          {
            id: 'not_existing_token',
            user: {
              password: '12345678',
              password_confirmation: '12345678'
            }
          }
        end

        it 'raises an error' do
          expect do
            patch :update, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end

      context 'TOKEN EXISTS' do
        let(:user) { FactoryGirl.create(:user) }
        before { set_password_reset_token(user, token) }

        context 'VALID PARAMS' do
          let(:valid_params) do
            {
              id: token,
              user: {
                password: '12345678',
                password_confirmation: '12345678'
              }
            }
          end

          it 'calls update_password method of PasswordResetService' do
            expect_any_instance_of(PasswordResetService).to receive(:update_password)
            patch :update, params: valid_params
          end

          it 'sets flash[:notice] message' do
            patch :update, params: valid_params
            expect(flash[:notice]).to be_present
          end

          it 'redirects to root' do
            patch :update, params: valid_params
            expect(response).to redirect_to root_path
          end
        end

        context 'INVALID PARAMS' do
          let(:invalid_params) do
            {
              id: token,
              user: {
                password: '12',
                password_confirmation: '123'
              }
            }
          end

          it 'calls update_password method of PasswordResetService' do
            expect_any_instance_of(PasswordResetService).to receive(:update_password)
            patch :update, params: invalid_params
          end

          it "renders 'password_resets/edit' template with status 422" do
            patch :update, params: invalid_params
            expect(response).to render_template('password_resets/edit')
            expect(response.status).to eq 422
          end
        end

        context 'PASSWORD RESET HAS EXPIRED' do
          before { user.update_attribute(:password_reset_sent_at, Time.zone.now - 2.hours) }
          let(:params) do
            {
              id: token,
              user: {
                password: '12345678',
                password_confirmation: '12345678'
              }
            }
          end

          it 'calls update_password method of PasswordResetService' do
            expect_any_instance_of(PasswordResetService).to receive(:update_password)
            patch :update, params: params
          end

          it 'assigns error message to @error' do
            patch :update, params: params
            expect(assigns(:error)).to be_present
          end

          it 'redirects to password resets new action' do
            patch :update, params: params
            expect(response).to redirect_to new_password_reset_path
          end
        end
      end
    end
  end
end
