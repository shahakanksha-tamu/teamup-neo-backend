# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Milestone, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      association = described_class.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many tasks' do
      association = described_class.reflect_on_association(:tasks)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    let(:project) { create(:project, start_date: Time.zone.today, end_date: Time.zone.today + 1.year) }

    context 'when start_date and deadline are within project dates' do
      it 'is valid' do
        milestone = described_class.new(
          title: 'Milestone 1',
          project:,
          start_date: Time.zone.today + 1.month,
          deadline: Time.zone.today + 6.months,
          status: 'Not Started'
        )
        expect(milestone).to be_valid
      end
    end

    context 'when start_date is before project start_date' do
      it 'is not valid' do
        milestone = described_class.new(
          project:,
          start_date: Time.zone.today - 1.day,
          deadline: Time.zone.today + 6.months,
          status: 'Not Started'
        )
        expect(milestone).not_to be_valid
        expect(milestone.errors[:start_date]).to include("must be within the project's start and end dates")
      end
    end

    context 'when some task is not completed' do
      it 'is not valid' do
        milestone = described_class.new(
          project:,
          title: 'Milestone 1',
          start_date: Time.zone.today + 1.day,
          deadline: Time.zone.today + 6.months,
          status: 'In-Progress'
        )
        create(:task, milestone: milestone, status: 'Not Started')

        milestone.status = 'Completed'
        expect(milestone).not_to be_valid
        expect(milestone.errors[:status]).to include("cannot be changed to 'Completed' unless all associated tasks are in 'Completed' status")
      end
    end
  end
end
