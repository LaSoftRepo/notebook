require 'rails_helper'

RSpec.describe StaticsController, type: :controller do
  describe 'ACTIONS' do
    describe 'GET #home' do
      it "renders 'statics/home'" do
        get :home
        expect(response).to render_template('statics/home')
        expect(response.status).to eq 200
      end
    end
  end
end
