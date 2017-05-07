require 'rails_helper'

RSpec.describe Notice, type: :model do
  describe 'FACTORIES' do
    it 'invalid_notice factory builds invalid notice' do
      expect(FactoryGirl.build(:invalid_notice).valid?).to eq false
    end

    it 'notice factory builds valid notice' do
      expect(FactoryGirl.build(:notice).valid?).to eq true
    end
  end
end
