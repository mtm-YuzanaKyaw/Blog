FactoryBot.define do
  factory :event do
    summary { "MyString" }
    google_event_id { "MyString" }
    calendar_id { "MyString" }
    user { nil }
  end
end
