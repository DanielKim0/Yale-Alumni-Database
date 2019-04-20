require "rails_helper"

RSpec.feature "user creates alumni" do
  scenario "with valid data" do
    visit root_path
    click_link "Create Alumnus"
    fill_in "First name", with: "Sample"
    fill_in "Last name", with: "Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Create Alumnus Record"

    click_link "Create Event"
    fill_in "Name", with: "Test Name"
    click_button "Create Event Record"

    click_link "Take Attendance"
    fill_in "Alumnus email", with: "sample@email.com"
    fill_in "Event name", with: "Test Name"
    click_button "Create Attendance Record"

    click_link "View Alumni"
    click_link "view"
    expect(page).to have_content("Test Name")
  end
end
