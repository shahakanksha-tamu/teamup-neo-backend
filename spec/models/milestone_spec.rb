require 'rails_helper'

RSpec.describe Milestone, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      association = Milestone.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many tasks' do
      association = Milestone.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
