# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enums' do
    it 'defines roles correctly' do
      expect(described_class.roles).to eq({ 'student' => 0, 'admin' => 1 })
    end

    it 'allows assigning roles' do
      user = described_class.new(role: :student)
      expect(user.role).to eq('student')

      user.role = :admin
      expect(user.role).to eq('admin')
    end
  end
end
