require "rails_helper"

RSpec.feature "user deletes events" do
  before(:each) do
    @event = FactoryBot.create(:event)
  end

  scenario "successfully, from events page" do
    visit event_path(@event)
    click_button "delete"
    expect(Event.count).to eq(0)
  end

  scenario "successfully, from events index" do
    visit events_path
    click_button "delete"
    expect(Event.count).to eq(0)
  end
end
