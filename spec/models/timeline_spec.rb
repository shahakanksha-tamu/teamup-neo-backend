require 'rails_helper'

RSpec.describe Timeline, type: :model do
  describe 'associations' do
    it 'belongs to a project' do
      association = Timeline.reflect_on_association(:project)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'has many milestones' do
      association = Timeline.reflect_on_association(:milestones)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:nullify)
    end
  end

  describe 'validations' do
    it 'requires a start_date' do
      timeline = Timeline.new(start_date: nil)
      expect(timeline.valid?).to be_falsey
      expect(timeline.errors[:start_date]).to include("can't be blank")
    end

    it 'requires an end_date' do
      timeline = Timeline.new(end_date: nil)
      expect(timeline.valid?).to be_falsey
      expect(timeline.errors[:end_date]).to include("can't be blank")
    end

    it 'validates end_date is after start_date' do
      timeline = Timeline.new(start_date: Date.today, end_date: Date.yesterday)
      expect(timeline.valid?).to be_falsey
      expect(timeline.errors[:end_date]).to include('must be after the start date')
    end
  end
end
