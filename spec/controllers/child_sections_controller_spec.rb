require 'rails_helper'

RSpec.describe ChildSectionsController, type: :controller do
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
    let(:parent_section) { FactoryGirl.create(:section, notebook: notebook) }
    let(:params) do
      {
        notebook_id: notebook.id,
        parent_section_id: parent_section.id
      }
    end

    describe 'GET #new' do
      it "renders 'sections/new'" do
        get :new, params: params
        expect(response).to render_template('sections/new')
        expect(response.status).to eq 200
      end

      it 'builds child section' do
        get :new, params: params
        expect(assigns(:section).parent_section).to eq parent_section
      end
    end

    describe 'POST #create' do
      context 'VALID PARAMS' do
        let(:valid_params) do
          params.merge(section: FactoryGirl.attributes_for(:section))
        end

        it 'creates new child section' do
          prev_count = parent_section.child_sections.count
          post :create, params: valid_params
          expect(
            parent_section.reload.child_sections.count - prev_count
          ).to eq 1
        end

        it 'calls create method of ChildSectionRecorder' do
          expect_any_instance_of(ChildSectionRecorder).to(
            receive(:create).and_return(
              FactoryGirl.create(
                :section,
                :child,
                parent_section: parent_section
              )
            )
          )
          post :create, params: valid_params
        end

        it 'sets flash[:success] message' do
          post :create, params: valid_params
          expect(flash[:success]).to be_present
        end

        it 'redirects to notices index action' do
          post :create, params: valid_params
          child_section = parent_section.reload.child_sections.last
          expect(response).to(
            redirect_to(
              notebook_section_notices_path(section_id: child_section.id)
            )
          )
        end
      end

      context 'INVALID PARAMS' do
        let(:invalid_params) do
          params.merge(section: FactoryGirl.attributes_for(:invalid_section))
        end

        it 'does not create new child section' do
          prev_count = parent_section.child_sections.count
          post :create, params: invalid_params
          expect(parent_section.reload.child_sections.count - prev_count).to eq 0
        end

        it 'calls create method of ChildSectionRecorder' do
          expect_any_instance_of(ChildSectionRecorder).to(
            receive(:create).and_return(
              FactoryGirl.build(
                :invalid_section,
                :child,
                parent_section: parent_section
              )
            )
          )
          post :create, params: invalid_params
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
  end
end
