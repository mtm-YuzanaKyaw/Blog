json.extract! event, :id, :summary, :google_event_id, :calendar_id, :user_id, :created_at, :updated_at
json.url event_url(event, format: :json)
