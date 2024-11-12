# frozen_string_literal: true

# Handles all functions concerning the Calendar view.
class CalendarsController < ApplicationController
  def index
    # Render the calendar index view
  end

  def calendars
    # Check if session has an authorization token
    if session[:authorization]
      client = Signet::OAuth2::Client.new(client_options)
      client.update!(session[:authorization])

      # Refresh the token if it has expired
      if client.expired?
        client.refresh!
        session[:authorization] = {
          token: client.access_token,
          refresh_token: client.refresh_token,
          expires_at: client.expires_at
        }
      end

      # Set up Google Calendar API service
      service = Google::Apis::CalendarV3::CalendarService.new
      service.authorization = client

      # Fetch the calendar list
      @calendar_list = service.list_calendar_lists
    else
      # Redirect to OAuth flow if not logged in with Google
      redirect_to action: :redirect
    end
  end

  def redirect
    # Redirect user to Google OAuth consent page if no token
    client = Signet::OAuth2::Client.new(client_options)

    respond_to do |format|
      format.json { render json: { url: client.authorization_uri.to_s } }
      format.html { redirect_to client.authorization_uri.to_s, allow_other_host: true }
    end
  end

  def callback
    # Get and store tokens after user grants permission
    client = Signet::OAuth2::Client.new(client_options)
    client.code = params[:code]
    response = client.fetch_access_token!

    # Store the OAuth tokens in the session
    session[:authorization] = {
      token: response['access_token'],
      refresh_token: response['refresh_token'],
      expires_at: Time.now + response['expires_in'].to_i
    }

    redirect_to calendar_view_path
  end

  private

  def client
    Signet::OAuth2::Client.new(client_options)
  end

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
