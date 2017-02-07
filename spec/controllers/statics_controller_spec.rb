require 'rails_helper'
# TODO: Add tests for render like in notebooks_controller_spec file.
# They should also check locals which are passed to template.
RSpec.describe StaticsController, type: :controller do
  shared_examples 'statics_controller' do
    describe 'GET #home' do
      it "renders 'statics/home' template" do
        get :home
        expect(response).to render_template('statics/home')
      end

      it 'returns status 200' do
        get :home
        expect(response.status).to eq 200
      end
    end
  end

  context 'LOGGED IN' do
    log_in

    include_examples 'statics_controller'
  end

  context 'LOGGED OUT' do
    log_out

    include_examples 'statics_controller'
  end
end
