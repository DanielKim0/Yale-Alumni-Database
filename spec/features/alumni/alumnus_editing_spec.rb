require "rails_helper"

RSpec.feature "user edits alumni" do
  let(:alumnus) { FactoryBot.create(:alumnus) }

  scenario "with valid data" do
    visit edit_alumnus_path(alumnus)
    fill_in "Name", with: "Sample Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Save changes"

    expect(page).to have_content("alumnus updated")
  end

  scenario "with invalid data" do
    visit edit_alumnus_path(alumnus)
    fill_in "Name", with: "Sample Name"
    fill_in "Email", with: ""
    click_button "Save changes"

    expect(page).to have_content("Email can't be blank")
  end
end
