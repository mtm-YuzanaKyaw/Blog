json.extract! post, :id, :title, :conntent, :user_id, :created_at, :updated_at
json.url post_url(post, format: :json)
