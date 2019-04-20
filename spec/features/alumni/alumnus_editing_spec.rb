require "rails_helper"

RSpec.feature "user edits alumni" do
  let(:alumnus) { FactoryBot.create(:alumnus) }

  scenario "with valid data" do
    visit edit_alumnus_path(alumnus)
    fill_in "First name", with: "Sample"
    fill_in "Last name", with: "Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Edit Alumnus Record"

    expect(page).to have_content("Alumnus updated.")
  end

  scenario "with invalid data" do
    visit edit_alumnus_path(alumnus)
    fill_in "First name", with: "Sample"
    fill_in "Last name", with: "Name"
    fill_in "Email", with: ""
    click_button "Edit Alumnus Record"

    expect(page).to have_content("Email can't be blank")
  end
end
