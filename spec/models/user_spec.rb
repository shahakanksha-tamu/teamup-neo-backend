# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'enums' do
    it 'defines roles correctly' do
      expect(User.roles).to eq({ "student" => 0, "admin" => 1 })
    end

    it 'allows assigning roles' do
      user = User.new(role: :student)
      expect(user.role).to eq('student')
      
      user.role = :admin
      expect(user.role).to eq('admin')
    end

  end
end
