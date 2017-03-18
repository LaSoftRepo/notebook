require 'rails_helper'

RSpec.describe NoticesController, type: :controller do
  context 'LOGGED IN' do
    log_in

    describe 'GET #index' do
      # TODO: add tests LOGGED IN NoticesController#index
    end

    describe 'GET #show' do
      # TODO: add tests LOGGED IN NoticesController#show
    end

    describe 'GET #new' do
      # TODO: add tests LOGGED IN NoticesController#new
    end

    describe 'POST #create' do
      # TODO: add tests LOGGED IN NoticesController#create
    end
  end

  context 'LOGGED OUT' do
    log_out

    describe 'GET #index' do
      # TODO: add tests LOGGED OUT NoticesController#index
    end

    describe 'GET #show' do
      # TODO: add tests LOGGED OUT NoticesController#show
    end

    describe 'GET #new' do
      # TODO: add tests LOGGED OUT NoticesController#new
    end

    describe 'POST #create' do
      # TODO: add tests LOGGED OUT NoticesController#create
    end
  end
end
