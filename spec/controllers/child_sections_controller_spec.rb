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
    # TODO: Add tests for child sections controller
  end
end
