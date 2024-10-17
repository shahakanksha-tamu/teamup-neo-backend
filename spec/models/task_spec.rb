require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it 'belongs to a milestone' do
      association = Task.reflect_on_association(:milestone)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has one task assignment' do
      association = Task.reflect_on_association(:task_assignment)
      expect(association.macro).to eq(:has_one)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'has one user through task assignment' do
      association = Task.reflect_on_association(:user)
      expect(association.macro).to eq(:has_one)
      expect(association.options[:through]).to eq(:task_assignment)
    end
  end

  describe 'validations' do
    it 'requires a task_name' do
      task = Task.new(task_name: nil)
      expect(task.valid?).to be_falsey
      expect(task.errors[:task_name]).to include("can't be blank")
    end

    it 'requires a status' do
      task = Task.new(status: nil)
      expect(task.valid?).to be_falsey
      expect(task.errors[:status]).to include("can't be blank")
    end
  end

  describe 'enums' do
    it 'defines status correctly' do
      expect(Task.statuses.keys).to include('Not Completed', 'Completed', 'Delayed')
    end
  end
end
