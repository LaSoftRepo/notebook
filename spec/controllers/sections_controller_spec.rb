require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  describe 'Authentication' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'Actions' do
    log_in
    let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }

    describe 'GET #index' do
      context 'current notebook belongs to current user' do
        let(:params) { { notebook_id: notebook.id } }

        it "renders 'sections/index' template" do
          get :index, params: params
          expect(response).to render_template('sections/index')
        end

        it 'returns status 200' do
          get :index, params: params
          expect(response.status).to eq 200
        end
      end

      context 'current notebook does not belong to current user' do
        let(:params) { { notebook_id: '12345678' } }

        it 'raise an error' do
          expect do
            get :index, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end
    end

    describe 'GET #new' do
      let(:params) { { notebook_id: notebook.id } }

       it "renders 'sections/new' template" do
        get :new, params: params
        expect(response).to render_template('sections/new')
      end

      it 'returns status 200' do
        get :new, params: params
        expect(response.status).to eq 200
      end

      context 'current notebook does not belong to current user' do
        let(:params) { { notebook_id: '12345678' } }

        it 'raise an error' do
          expect do
            get :new, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end
    end

    describe 'POST #create' do
      # TODO: add tests LOGGED IN SectionsController#create
    end
  end
end
