# frozen_string_literal: true

# Handles all functions concerning the Calendar view.
class CalendarsController < ApplicationController
  def index; end

  def calendars

    client = Signet::OAuth2::Client.new(client_options)

    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
    @user = User.find_by(id: current_user.id)  
    @role = current_user.role  
  end
  def redirect
    # Initialize @client with the client setup
    @client = client

    respond_to do |format|
      format.json { render json: { url: @client.authorization_uri.to_s } }
      format.html { redirect_to @client.authorization_uri.to_s, allow_other_host: true }
    end
  end
  def callback
    client = Signet::OAuth2::Client.new(client_options)
    authorization_code = params[:code]
    client.code = authorization_code
    response = client.fetch_access_token!
    session[:authorization] = response
    redirect_to calendar_view_path
  end
  private

  def client
    Signet::OAuth2::Client.new(client_options)  
  end

  def client_options
    {
      client_id:  ENV["GOOGLE_CLIENT_ID"],
      client_secret:ENV["GOOGLE_CLIENT_SECRET"],
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri:   "http://localhost:3000/callback" 
    }
  end
end
