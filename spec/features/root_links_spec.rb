require "rails_helper"

feature "user clicks on link" do
  scenario "to alumnus creation" do
    visit root_path
    click_link "New Alumnus"
    expect(page).to have_content("New Alumnus")
  end

  scenario "to event creation" do
    visit root_path
    click_link "New Event"
    expect(page).to have_content("New Event")
  end

  scenario "to attendance creation" do
    visit root_path
    click_link "Attendance"
    expect(page).to have_content("Attendance")
  end
end
