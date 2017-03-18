require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  context 'LOGGED IN' do
    let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }
    log_in

    describe 'GET #index' do
      context 'current notebook belongs to current user' do
        let(:params) { { notebook_id: notebook.id } }

        it "renders 'sections/index' template with notebook sections" do
          FactoryGirl.create_list(:section, 2, notebook: notebook)
          allow(controller).to receive(:render).with no_args
          expect(controller).to(
            receive(:render).with(
              'sections/index', locals: { sections: notebook.sections }
            )
          )
          get :index, params: params
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

  context 'LOGGED OUT' do
    log_out

    describe 'GET #index' do
      let(:params) { { notebook_id: FactoryGirl.create(:notebook).id } }

      it 'sets flash[:warning] message' do
        get :index, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to login path' do
        get :index, params: params
        expect(response).to redirect_to log_in_path
      end
    end

    describe 'GET #new' do
      let(:params) { { notebook_id: FactoryGirl.create(:notebook).id } }

      it 'sets flash[:warning] message' do
        get :new, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to login path' do
        get :new, params: params
        expect(response).to redirect_to log_in_path
      end
    end

    describe 'POST #create' do
      # TODO: add tests LOGGED OUT SectionsController#create
    end
  end
end
