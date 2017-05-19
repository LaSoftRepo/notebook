require 'rails_helper'

RSpec.describe Section, type: :model do
  describe 'FACTORIES' do
    it 'invalid_section factory builds invalid section' do
      expect(FactoryGirl.build(:invalid_section).valid?).to eq false
    end

    it 'section factory builds valid section' do
      expect(FactoryGirl.build(:section).valid?).to eq true
    end

    it 'trait child of factory section builds valid child section' do
      expect(FactoryGirl.build(:section, :child).parent_section?).to eq true
      expect(FactoryGirl.build(:section, :child).valid?).to eq true
    end

    it 'trait child of factory invalid_section builds invalid child section' do
      expect(FactoryGirl.build(:invalid_section, :child).parent_section?).to eq true
      expect(FactoryGirl.build(:invalid_section, :child).valid?).to eq false
    end
  end
end
