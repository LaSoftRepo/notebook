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
  end

  context 'LOGGED OUT' do
    log_out
  end
end
