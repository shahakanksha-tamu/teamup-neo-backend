class EventController < ApplicationController
  

  index do
    @events = Event.all
  end
end
