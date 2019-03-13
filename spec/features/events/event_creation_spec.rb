require "rails_helper"

RSpec.feature "user creates events" do
  scenario "with valid data" do
    visit root_path
    click_link "New Event"
    fill_in "Name", with: "Test Name"
    click_button "Create new event"

    expect(page).to have_content("Event successfully created!")
  end

  scenario "with invalid data" do
    visit root_path
    click_link "New Event"
    fill_in "Name", with: " "
    click_button "Create new event"

    expect(page).to have_content("Name can't be blank")
  end
end
