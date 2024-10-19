# frozen_string_literal: true

require 'simplecov'
SimpleCov.start 'rails' do
  add_filter '/app/channels/'
  add_filter '/app/jobs/'
  add_filter '/app/mailers/'
  add_filter '/app/models/'
end
