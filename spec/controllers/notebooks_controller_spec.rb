require 'rails_helper'

RSpec.describe NotebooksController, type: :controller do
  context 'LOGGED IN' do
    log_in

    describe 'GET #index' do
      it "renders 'notebooks/index' template with ordered desc by created_at notebooks of current user" do
        notebooks = FactoryGirl.create_list(:notebook, 2, user: controller.current_user)
        allow(controller).to receive(:render).with no_args
        expect(controller).to(
          receive(:render).with(
            'notebooks/index', locals: {
              notebooks: notebooks.sort { |x, y| y.created_at <=> x.created_at }
            }
          )
        )
        get :index
      end

      it 'returns status 200' do
        get :index
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do

      context 'WITH VALID PARAMS' do
        let(:valid_params) { { notebook: FactoryGirl.attributes_for(:notebook) } }

        it 'creates new notebook for current user' do
          expect do
            post :create, params: valid_params
          end.to change(controller.current_user.notebooks, :count).by(1)
        end

        it 'sets flash[:success] message' do
          post :create, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notebook sections path' do
          post :create, params: valid_params
          expect(response).to redirect_to(
            notebook_sections_path controller.current_user.notebooks.last
          )
        end
      end

      context 'WITH INVALID PARAMS' do
        let(:invalid_params) { { notebook: FactoryGirl.attributes_for(:invalid_notebook) } }

        it 'does not create new notebook' do
          expect do
            post :create, params: invalid_params
          end.to change(Notebook, :count).by(0)
        end

        it 'sets flash[:error] message' do
          post :create, params: invalid_params
          expect(flash[:error]).to be_present
        end

        it 'redirects to notebook_path' do
          post :create, params: invalid_params
          expect(response).to redirect_to notebooks_path
        end
      end
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #index' do
      it 'sets flash[:warning] message' do
        get :index
        expect(flash[:warning]).to be_present
      end

      it 'redirects to login path' do
        get :index
        expect(response).to redirect_to log_in_path
      end
    end
  end
end
