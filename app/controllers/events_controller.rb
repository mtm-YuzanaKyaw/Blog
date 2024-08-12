require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def calendars
    google_user

    @calendars = @calendar.list_calendar_lists.items
  end
  # GET /events or /events.json
  def index
    google_user

    @events = @calendar.list_events(params[:calendar_id])
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @calendar_id = params[:calendar_id]

  end

  # GET /events/1/edit
  def edit
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]

    @event.start_date = @event.start.to_date
    @event.start_time = @event.start.strftime("%H:%M")
    @event.end_date = @event.end.to_date
    @event.end_time = @event.end.strftime("%H:%M")
  end

  # POST /events or /events.json
  def create
    @calendar_id = params[:calendar_id]

    google_user

    get_google_event(params)

    @event = Event.new(event_params)

    g_event = @calendar.insert_event(@calendar_id,@google_event)

    @event.start = @start_time
    @event.end = @end_time
    @event.google_event_id = g_event.id
    @event.save

    redirect_to calendar_events_path(@calendar_id), notice: "Create Event Successfully"
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]

    @event = Event.find_by(google_event_id: params[:event_id])

    google_user
    get_google_event(params)

    @event.update(event_params)
    g_event = @calendar.update_event(@calendar_id,@event_id,@google_event)

    redirect_to calendar_events_path(@calendar_id), notice: "Update Event Successfully"
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @calendar.authorization = google_secret.to_authorization
    @calendar.authorization.refresh!

    @calendar.delete_event(@calendar_id,@event_id)
    @event.destroy!
    redirect_to calendar_events_path(@calendar_id), notice: "Delete Event Successfully"

  end

  private

    def set_event
      @event = Event.find_by(google_event_id: params[:event_id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:summary, :calendar_id, :user_id)
    end

    def google_user()
      @calendar = Google::Apis::CalendarV3::CalendarService.new
      @calendar.authorization = google_secret.to_authorization
      @calendar.authorization.refresh!
    end

  def google_secret

    Google::APIClient::ClientSecrets.new({
      "web" => {
        "access_token" => current_user.google_token,
        "refresh_token" => current_user.google_refresh_token,
        "client_id" => "518703441732-am4hmshlbv2kgpvlkcn4vqpje7uan8vv.apps.googleusercontent.com",
        "client_secret" => "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"
      }
    })
  end

  def get_google_event(params)

    event_params = params.require(:event).permit(:summary, :calendar_id, :user_id, :start_date, :start_time, :end_date, :end_time)

    #get datetime date with datetime_select form
    # @start_time = DateTime.new(
    #   event_params['start(1i)'].to_i,  # Year
    #   event_params['start(2i)'].to_i,  # Month
    #   event_params['start(3i)'].to_i,  # Day
    #   event_params['start(4i)'].to_i,  # Hour
    #   event_params['start(5i)'].to_i   # Minute
    # )

    #get datetime date with date_field and time_field
    @start_time = DateTime.parse("#{event_params['start_date']}T#{event_params['start_time']}").strftime('%Y-%m-%dT%H:%M:%S')
    @end_time = DateTime.parse("#{event_params['end_date']}T#{event_params['end_time']}").strftime('%Y-%m-%dT%H:%M:%S')

    #get datetime data with datetime_select form
    # @end_time = DateTime.new(
    #   event_params['end(1i)'].to_i,    # Year
    #   event_params['end(2i)'].to_i,    # Month
    #   event_params['end(3i)'].to_i,    # Day
    #   event_params['end(4i)'].to_i,    # Hour
    #   event_params['end(5i)'].to_i     # Minute
    # )

    @google_event = Google::Apis::CalendarV3::Event.new(
      summary: event_params[:summary],
      start: {
        date_time: @start_time,
        time_zone: 'Asia/Yangon'
      } ,
      end: {
        date_time:  @end_time,
        time_zone: 'Asia/Yangon'
      }
    )
  end

end
