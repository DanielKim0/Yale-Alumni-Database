require "rails_helper"

RSpec.feature "user creates alumni" do
  scenario "with valid data" do
    visit root_path
    click_link "New Alumnus"
    fill_in "Name", with: "Sample Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Create Alumnus Record"

    expect(page).to have_content("alumnus successfully created")
  end

  scenario "with invalid data" do
    visit root_path
    click_link "New Alumnus"
    fill_in "Name", with: "Sample Name"
    click_button "Create Alumnus Record"

    expect(page).to have_content("Email can't be blank")
  end
end
