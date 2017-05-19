require 'rails_helper'

RSpec.describe Notebook, type: :model do
  let(:notebook) { FactoryGirl.create(:notebook) }

  describe 'FACTORIES' do
    it 'invalid_notebook factory builds invalid notebook' do
      expect(FactoryGirl.build(:invalid_notebook).valid?).to eq false
    end

    it 'notebook factory builds valid notebook' do
      expect(FactoryGirl.build(:notebook).valid?).to eq true
    end
  end

  describe '#find_section' do
    it 'finds a section with any embedding by id' do
      section1    = FactoryGirl.build(:section, notebook: notebook)
      section11   = FactoryGirl.build(:section, :child, parent_section: section1)
      section12   = FactoryGirl.build(:section, :child, parent_section: section1)
      section121  = FactoryGirl.build(:section, :child, parent_section: section12)
      section1211 = FactoryGirl.build(:section, :child, parent_section: section121)

      expect(notebook.find_section(section1.id)).to    eq section1
      expect(notebook.find_section(section11.id)).to   eq section11
      expect(notebook.find_section(section12.id)).to   eq section12
      expect(notebook.find_section(section121.id)).to  eq section121
      expect(notebook.find_section(section1211.id)).to eq section1211
    end
  end
end
