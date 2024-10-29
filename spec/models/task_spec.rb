# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it 'belongs to a milestone' do
      association = described_class.reflect_on_association(:milestone)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has one task assignment' do
      association = described_class.reflect_on_association(:task_assignment)
      expect(association.macro).to eq(:has_one)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has one user through task assignment' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:has_one)
      expect(association.options[:through]).to eq(:task_assignment)
    end
  end

  describe 'validations' do
    it 'requires a task_name' do
      task = described_class.new(task_name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:task_name]).to include("can't be blank")
    end

    it 'requires a status' do
      task = described_class.new(status: nil)
      expect(task).not_to be_valid
      expect(task.errors[:status]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'defines status correctly' do
      expect(described_class.statuses.keys).to include('Not Completed', 'Completed', 'In-Progress', 'Not Started')
    end
  end
end
