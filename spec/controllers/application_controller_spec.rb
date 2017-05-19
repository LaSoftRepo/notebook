require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#not_found' do
    it 'raises ActionController::RoutingError' do
      expect do
        controller.not_found
      end.to raise_error ActionController::RoutingError
    end
  end

  describe '#authenticate_user' do
    context 'LOGGED IN' do
      log_in

      it 'does not set flash[:error] message' do
        controller.authenticate_user
        expect(flash[:error]).to eq nil
      end

      it 'does not redirect to login page' do
        expect(controller).not_to receive(:redirect_to)
        controller.authenticate_user
      end
    end

    context 'LOGGED OUT' do
      log_out

      it 'sets flash[:error] message' do
        allow(controller).to receive(:redirect_to)
        controller.authenticate_user
        expect(flash[:error]).to eq I18n.t('session.not_logged_in')
      end

      it 'redirects to login page' do
        expect(controller).to receive(:redirect_to).with(log_in_path)
        controller.authenticate_user
      end
    end
  end

  describe '#redirect_authenticated_user' do
    context 'LOGGED IN' do
      log_in

      it 'sets flash[:error] message' do
        allow(controller).to receive(:redirect_to)
        controller.redirect_authenticated_user
        expect(flash[:error]).to eq I18n.t('session.logged_in_already')
      end

      it 'redirect to root page' do
        expect(controller).to receive(:redirect_to).with(root_path)
        controller.redirect_authenticated_user
      end
    end

    context 'LOGGED OUT' do
      log_out

      it 'does not set flash[:error] message' do
        controller.redirect_authenticated_user
        expect(flash[:error]).to eq nil
      end

      it 'does not redirect to root page' do
        expect(controller).not_to receive(:redirect_to)
        controller.redirect_authenticated_user
      end
    end
  end

  describe '#verify_notebook' do
    context 'current_notebook method returns truthful value' do
      it 'does not call not_found method' do
        allow(controller).to receive(:current_notebook) { true }
        expect(controller).not_to receive(:not_found)
        controller.verify_notebook
      end
    end

    context 'current_notebook method returns NOT truthful value' do
      it 'calls not_found method' do
        allow(controller).to receive(:current_notebook) { false }
        expect(controller).to receive(:not_found)
        controller.verify_notebook
      end
    end
  end

  describe '#verify_section' do
    context 'notebook is verified' do
      before { allow(controller).to receive(:verify_notebook) }

      context 'current_section method returns truthful value' do
        it 'does not call not_found method' do
          allow(controller).to receive(:current_section) { true }
          expect(controller).not_to receive(:not_found)
          controller.verify_section
        end
      end

      context 'current_section method returns NOT truthful value' do
        it 'calls not_found method' do
          allow(controller).to receive(:current_section) { false }
          expect(controller).to receive(:not_found)
          controller.verify_section
        end
      end
    end

    context 'notebook is not verified' do
      context 'current_section method returns truthful value' do
        it 'calls not_found method' do
          allow(controller).to receive(:current_section) { true }
          expect(controller).to receive(:not_found)
          controller.verify_section
        end
      end

      context 'current_section method returns NOT truthful value' do
        it 'calls not_found method' do
          allow(controller).to receive(:current_section) { false }
          # We have to make two expectations. The first one stubs
          # not_found in verify_notebook method and the program goes further.
          # The second one stubs not_found in verify_section
          # in order to make this test pass.
          expect(controller).to receive(:not_found) # in verify_notebook
          expect(controller).to receive(:not_found) # in verify_section
          controller.verify_section
        end
      end
    end
  end
end
