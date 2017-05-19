require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end

    it 'verifies notebook in all actions' do
      expect(controller).to filter(:before, with: :verify_notebook)
    end
  end

  describe 'ACTIONS' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: current_user) }
    let(:section) { FactoryGirl.create(:section, notebook: notebook) }

    describe 'GET #index' do
      let(:params) { { notebook_id: notebook.id } }
      before { FactoryGirl.create_list(:section, 2, notebook: notebook) }

      it "renders 'sections/index'" do
        get :index, params: params
        expect(assigns(:sections)).to eq notebook.reload.sections
        expect(response).to render_template('sections/index')
        expect(response.status).to eq 200
      end
    end

    describe 'GET #new' do
      let(:params) { { notebook_id: notebook.id } }

       it "renders 'sections/new'" do
        get :new, params: params
        expect(response).to render_template('sections/new')
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          {
            section: FactoryGirl.attributes_for(:section),
            notebook_id: notebook.id
          }
        end

        it 'creates new section' do
          prev_count = notebook.sections.count
          post :create, params: valid_params
          expect(notebook.reload.sections.count - prev_count).to eq 1
        end

        it 'sets flash[:success] message' do
          post :create, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notices index action' do
          post :create, params: valid_params
          section = notebook.reload.sections.last
          expect(response).to(
            redirect_to notebook_section_notices_path(section_id: section.id)
          )
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) do
          {
            section: FactoryGirl.attributes_for(:invalid_section),
            notebook_id: notebook.id
          }
        end

        it 'does not create new section' do
          prev_count = notebook.sections.count
          post :create, params: invalid_params
          expect(notebook.reload.sections.count - prev_count).to eq 0
        end

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash.now[:error]).to be_present
        end

        it 'renders sections/new' do
          post :create, params: invalid_params
          expect(response).to render_template('sections/new')
          expect(response.status).to eq 422
        end
      end
    end

    describe 'GET #edit' do
      let(:params) { { notebook_id: notebook.id, id: section.id } }

      it 'renders sections/edit template' do
        get :edit, params: params
        expect(response).to render_template 'sections/edit'
      end
    end

    describe 'PATCH #update' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          {
            section: FactoryGirl.attributes_for(:section),
            notebook_id: notebook.id,
            id: section.id
          }
        end

        it 'updates section' do
          patch :update, params: valid_params
          section.reload
          valid_params[:section].each do |key, value|
            expect(section[key]).to eq value
          end
        end

        it 'sets flash[:success] message' do
          patch :update, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notices index action' do
          patch :update, params: valid_params
          expect(response).to(
            redirect_to notebook_section_notices_path(section_id: section.id)
          )
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) do
          {
            section: FactoryGirl.attributes_for(:invalid_section),
            notebook_id: notebook.id,
            id: section.id
          }
        end

        it 'does not update notebook' do
          patch :update, params: invalid_params
          section.reload
          invalid_params[:section].each do |key, value|
            expect(section[key]).not_to eq value
          end
        end

        it 'sets flash[:error] message' do
          patch :update, params: invalid_params
          expect(flash[:error]).to be_present
        end

        it "renders 'sections/edit'" do
          patch :update, params: invalid_params
          expect(response).to render_template('sections/edit')
          expect(response.status).to eq 422
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:params) { { notebook_id: notebook.id, id: section.id } }

      it 'deletes section' do
        prev_count = notebook.sections.count
        delete :destroy, params: params
        expect(notebook.reload.sections.count - prev_count).to eq -1
      end

      it 'sets flash[:notice] message' do
        delete :destroy, params: params
        expect(flash[:notice]).to be_present
      end

      it 'redirects to sections index action' do
        delete :destroy, params: params
        expect(response).to redirect_to notebook_sections_path
      end

      context 'CHILD SECTION' do
        let!(:params) do
          {
            notebook_id: notebook.id,
            id: FactoryGirl.create(:section, :child, parent_section: section).id
          }
        end

        it 'redirects to notices index action' do
          notebook.upsert # need to do that because after reload child section disappear
          delete :destroy, params: params
          expect(response).to(
            redirect_to notebook_section_notices_path(section_id: section.id)
          )
        end
      end
    end
  end

  describe '#find_section' do
    it 'is called as before action for edit, update and destroy' do
      expect(controller).to(
        filter(:before, with: :find_section, only: [:edit, :update, :destroy])
      )
    end

    context 'LOGGED IN' do
      log_in
      let(:notebook) { FactoryGirl.create(:notebook, user: current_user) }
      let(:section) { FactoryGirl.create(:section, notebook: notebook) }

      it 'finds section of current notebook by id from params' do
        controller.params[:notebook_id] = notebook.id
        controller.params[:id] = section.id
        controller.send(:find_section)
        expect(assigns(:section)).to eq section
      end

      it 'calls find_section to find section' do
        controller.params[:notebook_id] = notebook.id
        controller.params[:id] = section.id
        expect_any_instance_of(Notebook).to(
          receive(:find_section).with(section.id) { section }
        )
        controller.send(:find_section)
      end

      context 'INVALID ID' do
        it 'raises error ActionController::RoutingError' do
          controller.params[:notebook_id] = notebook.id
          controller.params[:id] = FactoryGirl.create(:section).id
          expect do
            controller.send(:find_section)
          end.to raise_error ActionController::RoutingError
        end
      end
    end

    context 'LOGGED OUT' do
      log_out

      it 'raises error NoMethodError' do
        notebook = FactoryGirl.create(:notebook)
        section  = FactoryGirl.create(:section, notebook: notebook)
        controller.params[:notebook_id] = notebook.id
        controller.params[:id] = section.id
        expect do
          controller.send(:find_section)
        end.to raise_error NoMethodError
      end
    end
  end
end
