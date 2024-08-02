require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  def calendars
    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = google_secret.to_authorization
    service.authorization.refresh!

    @calendars = service.list_calendar_lists.items
  end
  # GET /events or /events.json
  def index
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = google_secret.to_authorization
    calendar.authorization.refresh!

    @events = calendar.list_events(params[:calendar_id])
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @calendar_id = params[:calendar_id]
    @event = Google::Apis::CalendarV3::Event.new

  end

  # GET /events/1/edit
  def edit
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]
  end

  # POST /events or /events.json
  def create

    @calendar_id = params[:calendar_id]

    # event_params = params.require(:event).permit(:user_id,:summary,:start,:end,:calendar_id)
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = google_secret.to_authorization
    calendar.authorization.refresh!

    start_time = DateTime.new(
      params['[start(1i)]'].to_i,  # Year
      params['[start(2i)]'].to_i,  # Month
      params['[start(3i)]'].to_i,  # Day
      params['[start(4i)]'].to_i,  # Hour
      params['[start(5i)]'].to_i   # Minute
    )

    end_time = DateTime.new(
      params['[end(1i)]'].to_i,    # Year
      params['[end(2i)]'].to_i,    # Month
      params['[end(3i)]'].to_i,    # Day
      params['[end(4i)]'].to_i,    # Hour
      params['[end(5i)]'].to_i     # Minute
    )

    google_event = Google::Apis::CalendarV3::Event.new(
      summary: params[:summary],
      start: {
        date_time: start_time,
        time_zone: 'Asia/Yangon'
      } ,
      end: {
        date_time:  end_time,
        time_zone: 'Asia/Yangon'
      }
    )

    event = {
      'calendar_id' => @calendar_id,
      'user_id' => params[:user_id],
      'summary' => params[:summary],
      'start' => start_time,
      'end' => end_time
    }
    @event = Event.new(event)

    g_event = calendar.insert_event(@calendar_id,google_event)

    @event.google_event_id = g_event.id
    @event.save



    redirect_to calendar_events_path(@calendar_id), notice: "Create Event Successfully"

  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]

    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = google_secret.to_authorization
    calendar.authorization.refresh!

    event_params = params.require(:event).permit(:summary, :calendar_id, :user_id,:start,:end)

    start_time = DateTime.new(
      event_params['start(1i)'].to_i,  # Year
      event_params['start(2i)'].to_i,  # Month
      event_params['start(3i)'].to_i,  # Day
      event_params['start(4i)'].to_i,  # Hour
      event_params['start(5i)'].to_i   # Minute
    )

    end_time = DateTime.new(
      event_params['end(1i)'].to_i,    # Year
      event_params['end(2i)'].to_i,    # Month
      event_params['end(3i)'].to_i,    # Day
      event_params['end(4i)'].to_i,    # Hour
      event_params['end(5i)'].to_i     # Minute
    )

    google_event = Google::Apis::CalendarV3::Event.new(
      summary: event_params[:summary],
      start: {
        date_time: start_time,
        time_zone: 'Asia/Yangon'
      } ,
      end: {
        date_time:  end_time,
        time_zone: 'Asia/Yangon'
      }
    )

    event = {
      'summary' => params[:summary],
      'start' => start_time,
      'end' => end_time
    }
    @event.update(event_params)
    g_event = calendar.update_event(@calendar_id,@event_id,google_event)

    redirect_to calendar_events_path(@calendar_id), notice: "Update Event Successfully"
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = google_secret.to_authorization
    calendar.authorization.refresh!

    calendar.delete_event(@calendar_id,@event_id)
    @event.destroy!
    redirect_to calendar_events_path(@calendar_id), notice: "Delete Event Successfully"


    # respond_to do |format|
    #   format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
    #   format.json { head :no_content }
    # end
  end

  private

    def set_event
      @event = Event.find_by(google_event_id: params[:event_id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:summary, :calendar_id, :user_id)
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

end
