require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end

    it "verifies notebook for all actions" do
      expect(controller).to filter(:before, with: :verify_notebook)
    end
  end

  describe 'ACTIONS' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }

    describe 'GET #index' do
      context 'current notebook belongs to current user' do
        let(:params) { { notebook_id: notebook.id } }

        it "renders 'sections/index' template with status 200" do
          get :index, params: params
          expect(response).to render_template('sections/index')
          expect(response.status).to eq 200
        end
      end
    end

    describe 'GET #new' do
      let(:params) { { notebook_id: notebook.id } }

       it "renders 'sections/new' template with status 200" do
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

        it 'creates new section for current notebook' do
          # I don't know why, but "expect {}.to change..." doesn't work here
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
          # I don't know why, but "expect {}.to change..." doesn't work here
          prev_count = notebook.sections.count
          post :create, params: invalid_params
          expect(notebook.reload.sections.count - prev_count).to eq 0
        end

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash.now[:error]).to be_present
        end

        it 'renders sections/new template with status 422' do
          post :create, params: invalid_params
          expect(response).to render_template('sections/new')
          expect(response.status).to eq 422
        end
      end
    end
  end
end
