require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      summary: "MyString",
      google_event_id: "MyString",
      calendar_id: "MyString",
      user: nil
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[summary]"

      assert_select "input[name=?]", "event[google_event_id]"

      assert_select "input[name=?]", "event[calendar_id]"

      assert_select "input[name=?]", "event[user_id]"
    end
  end
end
