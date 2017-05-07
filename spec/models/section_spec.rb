require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'FACTORIES' do
    it 'invalid_section factory builds invalid section' do
      expect(FactoryGirl.build(:invalid_section).valid?).to eq false
    end

    it 'section factory builds valid section' do
      expect(FactoryGirl.build(:section).valid?).to eq true
    end
  end
end
