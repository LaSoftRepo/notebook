require 'rails_helper'

RSpec.describe ChildSectionsController, type: :controller do
  describe 'Authentication' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  describe 'Actions' do
    
  end
end
