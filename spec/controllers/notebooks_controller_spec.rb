require 'rails_helper'

# Not sure if we have to add context "INVALID ID".
# There're tests for find_notebook method, which covers invalid id case.
# That's why they are commented for now.

RSpec.describe NotebooksController, type: :controller do
  let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }

  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'ACTIONS' do
    log_in

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

      # context 'INVALID ID' do
      #   let(:params_with_invalid_id) { { id: FactoryGirl.create(:notebook).id } }
      #
      #   it 'raises error' do
      #     expect do
      #       get :edit, params: params_with_invalid_id
      #     end.to raise_error Mongoid::Errors::DocumentNotFound
      #   end
      # end
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

      # context 'INVALID ID' do
      #   let(:params_with_invalid_id) do
      #     {
      #       notebook: FactoryGirl.attributes_for(:notebook),
      #       id: FactoryGirl.create(:notebook).id
      #     }
      #   end
      #
      #   it 'raises error' do
      #     expect do
      #       patch :update, params: params_with_invalid_id
      #     end.to raise_error Mongoid::Errors::DocumentNotFound
      #   end
      # end
    end

    describe 'DELETE #destroy' do
      let!(:params) { { id: notebook.id } }

      it 'deletes notebook of current user' do
        expect do
          delete :destroy, params: params
        end.to change(controller.current_user.notebooks, :count).by(-1)
      end

      it 'redirects to notebooks path' do
        delete :destroy, params: params
        expect(response).to redirect_to notebook_path
      end

      # context 'INVALID ID' do
      #   let(:params_with_invalid_id) { { id: FactoryGirl.create(:notebook).id } }
      #
      #   it 'raises error' do
      #     expect do
      #       delete :destroy, params: params_with_invalid_id
      #     end.to raise_error Mongoid::Errors::DocumentNotFound
      #   end
      # end
    end
  end

  describe '#find_notebook' do
    it 'is called as before action for edit, update and destroy' do
      expect(controller).to(
        filter(:before, with: :find_notebook, only: [:edit, :update, :destroy])
      )
    end

    context 'LOGGED IN' do
      log_in

      it 'finds notebook of current user by id from params' do
        controller.params[:id] = notebook.id
        controller.send(:find_notebook)
        expect(assigns(:notebook)).to eq notebook
      end

      context 'INVALID ID' do
        it 'raises error DocumentNotFound' do
          controller.params[:id] = FactoryGirl.create(:notebook).id
          expect do
            controller.send(:find_notebook)
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end
    end

    context 'LOGGED OUT' do
      log_out

      it 'raises error NoMethodError' do
        controller.params[:id] = FactoryGirl.create(:notebook).id
        expect do
          controller.send(:find_notebook)
        end.to raise_error NoMethodError
      end
    end
  end
end
