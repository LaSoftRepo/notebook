require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'FACTORIES' do
    it 'invalid_user factory builds invalid user' do
      expect(FactoryGirl.build(:invalid_user).valid?).to eq false
    end

    it 'user factory builds valid user' do
      expect(FactoryGirl.build(:user).valid?).to eq true
    end
  end
end
