require 'rails_helper'

RSpec.describe NoticesController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'ACTIONS' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }
    let(:section) { FactoryGirl.create(:section, notebook: notebook) }

    describe 'GET #index' do
      let(:params) { { notebook_id: notebook.id, section_id: section.id } }

      it "renders 'notices/index' template with status 200" do
        get :index, params: params
        expect(response).to render_template('notices/index')
        expect(response.status).to eq 200
      end
    end

    describe 'GET #new' do
      let(:params) { { notebook_id: notebook.id, section_id: section.id } }

      it "renders 'notices/new' template with status 200" do
        get :new, params: params
        expect(response).to render_template('notices/new')
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          {
            notebook_id: notebook.id,
            section_id: section.id,
            notice: FactoryGirl.attributes_for(:notice)
          }
        end

        it 'creates new notice' do
          prev_count = section.notices.count
          post :create, params: valid_params
          expect(section.reload.notices.count - prev_count).to eq 1
        end

        it 'sets flash[:success] message' do
          post :create, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notice show action' do
          post :create, params: valid_params
          expect(response).to redirect_to(
            notebook_section_notice_path(id: section.reload.notices.last.id)
          )
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) do
          {
            notebook_id: notebook.id,
            section_id: section.id,
            notice: FactoryGirl.attributes_for(:invalid_notice)
          }
        end

        it 'does not create new notice' do
          prev_count = section.notices.count
          post :create, params: invalid_params
          expect(section.reload.notices.count - prev_count).to eq 0
        end

        it 'sets flash.now[:error] message' do
          post :create, params: invalid_params
          expect(flash.now[:error]).to be_present
        end

        it "renders 'notices/new' template with status 422" do
          post :create, params: invalid_params
          expect(response).to render_template('notices/new')
          expect(response.status).to eq 422
        end
      end
    end
  end
end
