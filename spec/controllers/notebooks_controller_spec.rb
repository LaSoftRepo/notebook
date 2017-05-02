require 'rails_helper'

RSpec.describe NotebooksController, type: :controller do
  describe 'Authentication' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'Actions' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }

    describe 'GET #index' do
      it "renders 'notebooks/index' template" do
        get :index
        expect(response).to render_template('notebooks/index')
      end

      it 'returns status 200' do
        get :index
        expect(response.status).to eq 200
      end
    end

    describe 'GET #new' do
      it "renders 'notebooks/new' template" do
        get :new
        expect(response).to render_template('notebooks/new')
      end

      it 'returns status 200' do
        get :new
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

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash.now[:error]).to be_present
        end

        it "renders 'notebooks/new' template" do
          post :create, params: invalid_params
          expect(response).to render_template('notebooks/new')
        end

        it 'returns status 422' do
          post :create, params: invalid_params
          expect(response.status).to eq 422
        end
      end
    end

    describe 'GET #edit' do
      let(:params) { { id: notebook.id } }

      it "renders 'notebooks/edit' template" do
        get :edit, params: params
        expect(response).to render_template('notebooks/edit')
      end

      it 'returns status 200' do
        get :edit, params: params
        expect(response.status).to eq 200
      end
    end

    describe 'PATCH #update' do
      # TODO: add tests LOGGED IN NotebooksController#update
    end
  end
end
