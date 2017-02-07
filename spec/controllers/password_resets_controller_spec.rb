require 'rails_helper'
# TODO: Add tests for render like in notebooks_controller_spec file.
# They should also check locals which are passed to template.
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
    end

    describe 'GET #edit' do
      let(:params) { { id: token } }
      before { set_password_reset_token(controller.current_user, params[:id]) }

      it 'sets flash[:warning] message' do
        get :edit, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        get :edit, params: params
        expect(response).to redirect_to root_path
      end
    end

    describe 'PATCH #update' do
      let(:params) do
        {
          id: token,
          user: { password: '123456', password_confirmation: '123456' }
        }
      end
      before { set_password_reset_token(controller.current_user, params[:id]) }

      it 'sets flash[:warning] message' do
        patch :update, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to root path' do
        patch :update, params: params
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #new' do
      it "renders 'password_reset/new' template" do
        get :new
        expect(response).to render_template('password_resets/new')
      end

      it 'returns status 200' do
        get :new
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'WITH VALID PARAMS' do
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

        it 'redirects to root path' do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end
      end

      context 'WITH INVALID PARAMS' do
        let(:invalid_params) { { password_reset: { email: 'invalid_email@example' } } }

        it 'calls send_instructions method of PasswordResetService' do
          expect_any_instance_of(PasswordResetService).to receive(:send_instructions) { false }
          post :create, params: invalid_params
        end

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash.now[:error]).to be_present
        end

        it "renders 'password_resets/new' template" do
          post :create, params: invalid_params
          expect(response).to render_template('password_resets/new')
        end

        it 'returns status 400' do
          post :create, params: invalid_params
          expect(response.status).to eq 400
        end
      end
    end

    describe 'GET #edit' do
      context 'TOKEN DOES NOT EXIST' do
        let(:params) { { id: 'not_existing_token' } }

        it 'raise an errors' do
          expect do
            get :edit, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end

      context 'TOKEN EXISTS' do
        let(:params) { { id: token } }
        before { set_password_reset_token(FactoryGirl.create(:user), params[:id]) }

        it "renders 'password_resets/edit' template" do
          get :edit, params: params
          expect(response).to render_template('password_resets/edit')
        end

        it 'returns status 200' do
          get :edit, params: params
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

        context 'WITH VALID PARAMS' do
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

          it 'redirects to root path' do
            patch :update, params: valid_params
            expect(response).to redirect_to root_path
          end
        end

        context 'WITH INVALID PARAMS' do
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

          it 'sets flash.now[:error] message' do
            patch :update, params: invalid_params
            expect(flash.now[:error]).to be_present
          end

          it "renders 'password_resets/edit' template" do
            patch :update, params: invalid_params
            expect(response).to render_template 'password_resets/edit'
          end

          it 'returns status 400' do
            patch :update, params: invalid_params
            expect(response.status).to eq 400
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

          it 'sets flash[:warning] message' do
            patch :update, params: params
            expect(flash[:warning]).to be_present
          end

          it 'redirects to new password reset path' do
            patch :update, params: params
            expect(response).to redirect_to new_password_reset_path
          end
        end
      end
    end
  end
end
