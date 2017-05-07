require 'rails_helper'

RSpec.describe NotebooksController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'ACTIONS' do
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
      context 'VALID PARAMS' do
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

      context 'INVALID PARAMS' do
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
      context 'VALID PARAMS' do
        let(:valid_params) do
          {
            notebook: FactoryGirl.attributes_for(:notebook),
            id: notebook.id
          }
        end

        it 'updates notebook' do
          patch :update, params: valid_params
          notebook.reload
          valid_params[:notebook].each do |key, value|
            expect(notebook[key]).to eq value
          end
        end

        it 'sets flash[:success] message' do
          patch :update, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notebook sections path' do
          patch :update, params: valid_params
          expect(response).to redirect_to notebook_sections_path(notebook)
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) do
          {
            notebook: FactoryGirl.attributes_for(:invalid_notebook),
            id: notebook.id
          }
        end

        it 'does not update notebook' do
          patch :update, params: invalid_params
          notebook.reload
          invalid_params[:notebook].each do |key, value|
            expect(notebook[key]).not_to eq value
          end
        end

        it 'sets flash[:error] message' do
          patch :update, params: invalid_params
          expect(flash[:error]).to be_present
        end

        it "renders 'notebooks/edit' template" do
          patch :update, params: invalid_params
          expect(response).to render_template('notebooks/edit')
        end
      end

      context 'INVALID ID' do
        let(:params) do
          {
            notebook: FactoryGirl.attributes_for(:notebook),
            id: FactoryGirl.create(:notebook).id
          }
        end

        it 'raises an error' do
          expect do
            patch :update, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end
    end
  end
end
