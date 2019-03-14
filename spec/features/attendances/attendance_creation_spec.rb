require "rails_helper"

RSpec.feature "user creates attendance" do
  before do
    @alumnus = FactoryBot.create(:alumnus)
    @event = FactoryBot.create(:event)
  end

  scenario "with valid data" do
    visit root_path
    click_link "Attendance"
    fill_in "Alumnus email", with: @alumnus.email
    fill_in "Event name", with: @event.name
    click_button "Create Attendance Record"

    expect(page).to have_content("Attendance successfully logged!")
  end

  scenario "with invalid data" do
    visit root_path
    click_link "Attendance"
    fill_in "Alumnus email", with: @alumnus.email
    fill_in "Event name", with: "fake_name"
    click_button "Create Attendance Record"

    expect(page).to have_content("Event can't be blank")
  end
end
