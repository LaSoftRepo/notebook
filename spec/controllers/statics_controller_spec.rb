require 'rails_helper'

RSpec.describe StaticsController, type: :controller do
  describe 'Actions' do
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
end
