require "rails_helper"

RSpec.feature "user creates alumni" do
  scenario "with valid data" do
    visit root_path
    click_link "Create Alumnus"
    fill_in "First name", with: "Sample"
    fill_in "Last name", with: "Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Create Alumnus Record"

    expect(page).to have_content("Alumnus successfully created!")
    expect(page).to have_title("Sample Name")
  end

  scenario "with invalid data" do
    visit root_path
    click_link "Create Alumnus"
    fill_in "First name", with: "Sample"
    fill_in "Last name", with: "Name"
    click_button "Create Alumnus Record"

    expect(page).to have_content("Email can't be blank")
  end
end
