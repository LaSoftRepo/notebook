require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
      let(:params) { { user: FactoryGirl.attributes_for(:user) } }

      it 'sets flash[:warning] message' do
        post :create, params: params
        expect(flash[:warning]).to be_present
      end

      it "redirects to root path" do
        post :create, params: params
        expect(response).to redirect_to root_path
      end

      it 'returns status 302' do
        post :create, params: params
        expect(response.status).to eq 302
      end
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #new' do
      it "renders 'users/new' template" do
        get :new
        expect(response).to render_template('users/new')
      end

      it 'returns status 200' do
        get :new
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'WITH VALID PARAMS' do
        let(:valid_params) { { user: FactoryGirl.attributes_for(:user) } }

        it 'creates new user' do
          expect do
            post :create, params: valid_params
          end.to change(User, :count).by(1)
        end

        it 'calls create method of UserRecorder' do
          expect_any_instance_of(UserRecorder).to receive(:create) { FactoryGirl.create :user }
          post :create, params: valid_params
        end

        it 'authenticates created user' do
          valid_params[:user][:email] = 'new@user.com'
          post :create, params: valid_params
          expect(controller.current_user.email).to eq valid_params[:user][:email]
        end

        it 'sets flash[:notice] message' do
          post :create, params: valid_params
          expect(flash[:notice]).to be_present
        end

        it 'redirects to root path' do
          post :create, params: valid_params
          expect(response).to redirect_to root_path
        end

        it 'returns status 302' do
          post :create, params: valid_params
          expect(response.status).to eq 302
        end
      end

      context 'WITH INVALID PARAMS' do
        let(:invalid_params) { { user: FactoryGirl.attributes_for(:invalid_user) } }

        it 'does not create new user' do
          expect do
            post :create, params: invalid_params
          end.not_to change(User, :count)
        end

        it 'calls create method of UserRecorder' do
          expect_any_instance_of(UserRecorder).to receive(:create) { FactoryGirl.build :invalid_user }
          post :create, params: invalid_params
        end

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash[:error]).to be_present
        end

        it "renders 'users/new' template" do
          post :create, params: invalid_params
          expect(response).to render_template('users/new')
        end

        it 'returns status 400' do
          post :create, params: invalid_params
          expect(response.status).to eq 400
        end
      end
    end
  end
end
