require 'rails_helper'

RSpec.describe NoticesController, type: :controller do
  describe 'AUTHENTICATION' do
    it "doesn't allow unauthenticated users to access all actions" do
      expect(controller).to filter(:before, with: :authenticate_user)
    end
  end

  context 'ACTIONS' do
    log_in

    describe 'GET #index' do
      # TODO: add tests NoticesController#index
    end

    describe 'GET #show' do
      # TODO: add tests NoticesController#show
    end

    describe 'GET #new' do
      # TODO: add tests NoticesController#new
    end

    describe 'POST #create' do
      # TODO: add tests NoticesController#create
    end
  end
end
