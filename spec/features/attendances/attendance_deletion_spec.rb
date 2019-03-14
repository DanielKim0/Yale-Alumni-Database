require "rails_helper"

RSpec.feature "user deletes attendance" do
  before do
    @alumnus = FactoryBot.create(:alumnus, id: 100)
    @event = FactoryBot.create(:event, id: 100)
  end

  scenario "successfully, from alumnus page" do
    visit alumnus_path(@alumnus)
    click_link "delete"
    expect(Attendance.count).to eq(0)
  end

  scenario "successfully, from event index" do
    visit event_path(@event)
    click_link "delete"
    expect(Attendance.count).to eq(0)
  end
end
