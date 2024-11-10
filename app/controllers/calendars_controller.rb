# frozen_string_literal: true

# Handles all functions concerning the Calendar view.
class CalendarsController < ApplicationController
  def index; end

  def calendars
    puts "Ramneek Ramneek Ramneek"

    client = Signet::OAuth2::Client.new(client_options)

    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
       # Debugging: Print the response to the console
       puts "DEBUG: Calendar List Response: #{@calendar_list.inspect}"

       # Debugging: Check if the calendar list is nil or empty
       if @calendar_list.nil?
         puts "DEBUG: Calendar list is nil"
       elsif @calendar_list.items.nil? || @calendar_list.items.empty?
         puts "DEBUG: No calendars found"
       else
         puts "DEBUG: Found #{@calendar_list.items.count} calendars"
       end
    @user = User.find_by(id: current_user.id)  # Example to get user details
    @role = current_user.role  # Assuming role is part of your user model
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
    Signet::OAuth2::Client.new(client_options)  # Using `Signet::OAuth2::Client` to create the OAuth2 client
  end

  def client_options
    {
      client_id: "",
      client_secret:"",
      authorization_uri: "https://accounts.google.com/o/oauth2/auth",
      token_credential_uri: "https://oauth2.googleapis.com/token",
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY,
      redirect_uri:   "http://localhost:3000/callback" # Ensure `callback_url` is defined in your routes
    }
  end
end
