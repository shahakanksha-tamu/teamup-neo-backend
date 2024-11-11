# frozen_string_literal: true
class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy]

  def index
    @events = Event.all
    @event = Event.new

    render :index
  end

  def create
    @events = Event.update_all(show: false) # rubocop:disable Rails/SkipsModelValidations
    @event = Event.new(event_params.merge(show: true))
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      @events = Event.all
      render :index
    end
  end

  def edit
    @event = Event.find(params[:id])
    @events = Event.all
    render :index # This will render the index view with the form populated with @event data
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to events_path, notice: 'Event was successfully updated.'
    else
      flash[:error] = 'Failed to update event'
      @events = Event.all
      render :index
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed.'
  end

  def update_show
    @event = Event.find(params[:id])
    show_status = params[:show] == '1' # Checkbox sends "1" when checked, "0" when unchecked

    if show_status
      Event.update_all(show: false) # Set all other events to false
      @event.update(show: true)
      message = 'Event was successfully broadcasted.'
    else
      @event.update(show: false)
      message = 'Broadcasting was turned off for this event.'
    end

    redirect_to events_path, notice: message # Redirect to refresh the page and show the updated status
  end

  private

  def set_event
    @events = Event.all
  end

  def event_params
    params.require(:event).permit(:title, :description)
  end
end
