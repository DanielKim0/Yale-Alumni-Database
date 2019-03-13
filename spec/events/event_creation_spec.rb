require "rails_helper"

feature "user creates event" do
  scenario "with valid data" do
    visit root_path
    click_link "Create a new event!"
    fill_in "Name", with: "QWERTY"
    click_button "Create new event"

    expect(page).to have_content("Event successfully created")
  end

  scenario "with invalid data" do
    visit root_path
    click_link "Create a new event!"
    fill_in "Name", with: " "
    click_button "Create new event"

    expect(page).to have_content("Event successfully created")
  end
end
