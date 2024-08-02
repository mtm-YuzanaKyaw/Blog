require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        summary: "Summary",
        google_event_id: "Google Event",
        calendar_id: "Calendar",
        user: nil
      ),
      Event.create!(
        summary: "Summary",
        google_event_id: "Google Event",
        calendar_id: "Calendar",
        user: nil
      )
    ])
  end

  it "renders a list of events" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Summary".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Google Event".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Calendar".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
