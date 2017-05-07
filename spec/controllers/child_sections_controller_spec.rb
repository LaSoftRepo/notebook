require 'rails_helper'

RSpec.describe ChildSectionsController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'ACTIONS' do

  end
end
