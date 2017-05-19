require 'rails_helper'

RSpec.describe NoticesController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'ACTIONS' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: current_user) }
    let(:section) { FactoryGirl.create(:section, notebook: notebook) }
    let(:params) { { notebook_id: notebook.id, section_id: section.id } }

    describe 'GET #index' do
      before do
        FactoryGirl.create_list(:notice, 2, section: section)
        FactoryGirl.create_list(:section, 2, :child, parent_section: section)
      end

      it "renders 'notices/index'" do
        get :index, params: params
        expect(assigns(:notices)).to eq section.reload.notices
        expect(assigns(:child_sections)).to eq section.reload.child_sections
        expect(response).to render_template('notices/index')
        expect(response.status).to eq 200
      end
    end

    describe 'GET #show' do
      let(:notice) { FactoryGirl.create(:notice, section: section) }
      before { params.merge!(id: notice.id) }

      it "renders 'notices/show'" do
        get :show, params: params
        expect(assigns(:notice)).to eq notice
        expect(response).to render_template('notices/show')
        expect(response.status).to eq 200
      end
    end

    describe 'GET #new' do
      it "renders 'notices/new'" do
        get :new, params: params
        expect(response).to render_template('notices/new')
        expect(response.status).to eq 200
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          params.merge(notice: FactoryGirl.attributes_for(:notice))
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
          params.merge(notice: FactoryGirl.attributes_for(:invalid_notice))
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

        it "renders 'notices/new'" do
          post :create, params: invalid_params
          expect(response).to render_template('notices/new')
          expect(response.status).to eq 422
        end
      end
    end

    describe 'GET #edit' do
      let(:notice) { FactoryGirl.create(:notice, section: section) }
      before { params.merge!(id: notice.id) }

      it "renders 'notices/edit'" do
        get :edit, params: params
        expect(response).to render_template('notices/edit')
        expect(response.status).to eq 200
      end
    end
  end
end
