# frozen_string_literal: true

require 'rails_helper'
require 'google/apis/calendar_v3'
require 'signet/oauth_2/client'

RSpec.describe CalendarsController, type: :controller do
  let(:user) { create(:user) }
  let(:client_options) do
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: callback_url,
      login_hint: user.email,
      prompt: 'none'
    }
  end

  before do
    session[:user_id] = user.id
    allow(controller).to receive_messages(current_user: user, callback_url: 'http://test.host/callback')
  end

  describe 'GET #calendars' do
    context 'when user is authenticated with Google' do
      let(:client) { instance_double(Signet::OAuth2::Client) }
      let(:service) { instance_double(Google::Apis::CalendarV3::CalendarService) }
      let(:calendar_list) { instance_double(Google::Apis::CalendarV3::CalendarList) }
      let(:auth_hash) do
        {
          token: 'fake_access_token',
          refresh_token: 'fake_refresh_token',
          expires_at: Time.zone.now + 3600
        }
      end

      before do
        session[:authorization] = auth_hash
        allow(Signet::OAuth2::Client).to receive(:new).and_return(client)
        allow(Google::Apis::CalendarV3::CalendarService).to receive(:new).and_return(service)
        allow(client).to receive(:update!)
        allow(service).to receive(:authorization=)
        allow(service).to receive(:list_calendar_lists).and_return(calendar_list)
      end

      context 'when token is valid' do
        before do
          allow(client).to receive(:expired?).and_return(false)
        end

        it 'fetches the calendar list' do
          get :calendars
          expect(assigns(:calendar_list)).to eq(calendar_list)
        end
      end

      context 'when token is expired' do
        before do
          allow(client).to receive_messages(expired?: true, refresh!: true)
          allow(session[:authorization]).to receive(:[]=)
        end

        it 'refreshes the token and updates the session' do
          get :calendars
          expect(session[:authorization]).to include(
            token: 'fake_access_token',
            refresh_token: 'fake_refresh_token'
          )
        end
      end
    end
  end
end
