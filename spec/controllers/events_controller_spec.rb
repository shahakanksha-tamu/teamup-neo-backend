# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:logged_in_user) do
    User.create!(first_name: 'First Name', last_name: 'Last Name', contact: '1786839273', role: 'admin', email: 'firstname@gmail.com')
  end

  before do
    session[:user_id] = logged_in_user.id
    Event.create(title: 'event 1 title', description: 'event 1 description')
    allow(controller).to receive(:current_user).and_return(logged_in_user)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'redirects to the events index page' do
      post :create, params: { event: { title: 'Event 2', description: 'Event 2 description', date: 1.week.from_now } }
      expect(response).to redirect_to(events_path)
    end

    context 'when the event fails to save' do
      it 'renders the index template with errors' do
        allow_any_instance_of(Event).to receive(:save).and_return(false)

        post :create, params: { event: { title: '', description: '' } }

        expect(response).to render_template(:index)
        expect(assigns(:events)).to eq(Event.all)
      end
    end
  end

  describe 'PATCH #update' do
    it 'redirects to the events index page' do
      event = Event.find_by(title: 'event 1 title')
      patch :update, params: { id: event.id, event: { title: 'Event 1 updated', description: 'Event 1 description updated' } }
      expect(response).to redirect_to(events_path)
    end

    it 'sets flash error message when update fails' do
      event = Event.find_by(title: 'event 1 title')

      allow_any_instance_of(Event).to receive(:update).and_return(false)

      patch :update, params: { id: event.id, event: { title: 'Event 1 updated', description: 'Event 1 description updated' } }

      expect(flash[:error]).to eq('Failed to update event')
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      event = Event.find_by(title: 'event 1 title')
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    it 'redirects to the events index page' do
      event = Event.find_by(title: 'event 1 title')
      delete :destroy, params: { id: event.id }
      expect(response).to redirect_to(events_path)
    end
  end

  describe 'GET #edit for event' do
    it 'assigns the requested event to @event' do
      event = Event.find_by(title: 'event 1 title')
      get :edit, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end
  end

  # describe 'PATCH #update_show' do
  #   it 'redirects to the events index page' do
  #     event = Event.find_by(title: 'event 1 title')
  #     patch :update_show, params: { id: event.id, show: '1' }
  #     expect(response).to redirect_to(events_path)
  #   end
  # end

  describe 'PATCH #update_show' do
    it 'redirects to the events index page when show is set to 1' do
      event = Event.find_by(title: 'event 1 title')
      patch :update_show, params: { id: event.id, show: '1' }
      expect(response).to redirect_to(events_path)
    end

    it 'redirects to the events index page when show is set to 0' do
      event = Event.find_by(title: 'event 1 title')
      patch :update_show, params: { id: event.id, show: '0' }
      expect(response).to redirect_to(events_path)
    end
  end
end
