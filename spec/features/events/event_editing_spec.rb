require "rails_helper"

RSpec.feature "user edits events" do
  let(:event) { FactoryBot.create(:event) }

  scenario "with valid data" do
    visit edit_event_path(event)
    fill_in "Name", with: "Sample Event"
    click_button "Save changes"

    expect(page).to have_content("Event updated")
  end

  scenario "with invalid data" do
    visit edit_event_path(event)
    fill_in "Name", with: ""
    click_button "Save changes"

    expect(page).to have_content("Name can't be blank")
  end
end
