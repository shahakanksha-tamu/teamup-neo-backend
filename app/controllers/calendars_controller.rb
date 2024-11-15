# frozen_string_literal: true

class CalendarsController < ApplicationController
  def calendars
    if session[:authorization]
      client = Signet::OAuth2::Client.new(client_options)
      client.update!(session[:authorization])
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client
      @calendar_list = service.list_calendar_lists
    end
  end

  private

  def client_options
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri: callback_url,
      login_hint: current_user.email,  # Suggests which account to log in with
      prompt: 'none'  # Prevents the account selection screen from showing
    }
  end
end