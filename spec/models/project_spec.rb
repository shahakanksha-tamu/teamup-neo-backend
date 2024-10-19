# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it 'has many student assignments' do
      association = described_class.reflect_on_association(:student_assignments)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has many users through student assignments' do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:student_assignments)
    end

    it 'has many milestones' do
      association = described_class.reflect_on_association(:milestones)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has one timeline' do
      association = described_class.reflect_on_association(:timeline)
      expect(association.macro).to eq(:has_one)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end
end
