require 'rails_helper'

RSpec.describe Notebook, type: :model do
  describe 'FACTORIES' do
    it 'invalid_notebook factory builds invalid notebook' do
      expect(FactoryGirl.build(:invalid_notebook).valid?).to eq false
    end

    it 'notebook factory builds valid notebook' do
      expect(FactoryGirl.build(:notebook).valid?).to eq true
    end
  end
end
