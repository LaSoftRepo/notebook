require 'rails_helper'

RSpec.describe NotebooksController, type: :controller do
  context 'LOGGED IN' do
    log_in

    describe 'GET #index' do
      it "renders 'notebooks/index' template with notebooks of current user" do
        notebooks = FactoryGirl.create_list(:notebook, 2, user: controller.current_user)
        allow(controller).to receive(:render).with no_args
        expect(controller).to(
          receive(:render).with(
            'notebooks/index', locals: { notebooks: notebooks }
          )
        )
        get :index
      end

      it 'returns status 200' do
        get :index
        expect(response.status).to eq 200
      end
    end

    describe 'GET #show' do
      context 'notebook belongs to current user' do
        let(:notebook) { FactoryGirl.create(:notebook, user: controller.current_user) }
        let(:params) { { id: notebook.id } }

        it "renders 'notebooks/show' template with notebook" do
          allow(controller).to receive(:render).with no_args
          expect(controller).to(
            receive(:render).with(
              'notebooks/show', locals: { notebook: notebook }
            )
          )
          get :show, params: params
        end

        it 'returns status 200' do
          get :show, params: params
          expect(response.status).to eq 200
        end
      end

      context 'notebook does not belong to current user' do
        let(:params) { { id: FactoryGirl.create(:notebook).id } }

        it 'raise an error' do
          expect do
            get :show, params: params
          end.to raise_error Mongoid::Errors::DocumentNotFound
        end
      end
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #index' do
      it 'sets flash[:warning] message' do
        get :index
        expect(flash[:warning]).to be_present
      end

      it 'redirects to login path' do
        get :index
        expect(response).to redirect_to log_in_path
      end
    end

    describe 'GET #show' do
      let(:notebook) { FactoryGirl.create(:notebook) }
      let(:params) { { id: notebook.id } }

      it 'sets flash[:warning] message' do
        get :show, params: params
        expect(flash[:warning]).to be_present
      end

      it 'redirects to login path' do
        get :show, params: params
        expect(response).to redirect_to log_in_path
      end
    end
  end
end
