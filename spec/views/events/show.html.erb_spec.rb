require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    assign(:event, Event.create!(
      summary: "Summary",
      google_event_id: "Google Event",
      calendar_id: "Calendar",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Summary/)
    expect(rendered).to match(/Google Event/)
    expect(rendered).to match(/Calendar/)
    expect(rendered).to match(//)
  end
end
