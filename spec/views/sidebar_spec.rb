require "rails_helper"

feature "user clicks on link" do
  scenario "to alumnus creation" do
    visit root_path
    click_link "Create Alumnus"
    expect(page).to have_content("Alumni Import")
  end

  scenario "to event creation" do
    visit root_path
    click_link "Create Event"
    expect(page).to have_content("Event Import")
  end

  scenario "to attendance creation" do
    visit root_path
    click_link "Take Attendance"
    expect(page).to have_content("Attendance Import")
  end

  scenario "to about page" do
    visit root_path
    click_link "About"
    expect(page).to have_content("About")
  end

  scenario "to students page" do
    visit root_path
    click_link "View Students"
    expect(page).to have_content("View All Students")
  end

  scenario "to students creation" do
    visit root_path
    click_link "Create Student"
    expect(page).to have_content("Create Student")
  end

  scenario "to event page" do
    visit root_path
    click_link "View Events"
    expect(page).to have_content("View All Events")
  end

  scenario "to alumnus page" do
    visit root_path
    click_link "View Alumni"
    expect(page).to have_content("View All Alumni")
  end

  scenario "to home page" do
    visit about_path
    click_link "Home"
    expect(page).to have_content("Home")
  end
end
