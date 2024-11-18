# frozen_string_literal: true

# A controller for google calendar
class CalendarsController < ApplicationController
  # def calendars
  #   return unless session[:authorization]

  #   client = Signet::OAuth2::Client.new(client_options)
  #   client.update!(session[:authorization])
  #   service = Google::Apis::CalendarV3::CalendarService.new
  #   service.authorization = client
  #   @calendar_list = service.list_calendar_lists
  # end
  def calendars
    return unless session[:authorization]

    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists

    # Fetch events for the selected calendar or the first one
    if params[:calendar_id].present?
      @events = service.list_events(params[:calendar_id], single_events: true, order_by: 'startTime', time_min: Time.now.iso8601)
    elsif @calendar_list.items.any?
      default_calendar_id = @calendar_list.items.first.id
      @events = service.list_events(default_calendar_id, single_events: true, order_by: 'startTime', time_min: Time.now.iso8601)
    else
      @events = []
    end
  end
  private

  def client_options
    {
      client_id: Rails.application.credentials.google[:client_id],
      client_secret: Rails.application.credentials.google[:client_secret],
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://oauth2.googleapis.com/token',
      scope: 'https://www.googleapis.com/auth/calendar.events.public.readonly',
      redirect_uri: callback_url,
      login_hint: current_user.email, # Suggests which account to log in with
      prompt: 'none' # Prevents the account selection screen from showing
    }
  end
end
