require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  let(:event) {
    Event.create!(
      summary: "MyString",
      google_event_id: "MyString",
      calendar_id: "MyString",
      user: nil
    )
  }

  before(:each) do
    assign(:event, event)
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(event), "post" do

      assert_select "input[name=?]", "event[summary]"

      assert_select "input[name=?]", "event[google_event_id]"

      assert_select "input[name=?]", "event[calendar_id]"

      assert_select "input[name=?]", "event[user_id]"
    end
  end
end
