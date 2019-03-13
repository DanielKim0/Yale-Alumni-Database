require "rails_helper"

RSpec.feature "user searches for events" do
  let(:event) {FactoryBot.create(:event) }
  scenario "with a result" do
    visit events_path
    fill_in "search", with: event.name
    click_button 'Search'
    expect(page).to have_content(event.name)
  end

  scenario "without a result" do
    visit events_path
    fill_in 'search', with: 'Test'
    click_button 'Search'
    expect(page).not_to have_content(event.name)
  end

  scenario "with an empty search box" do
    visit events_path
    fill_in 'search', with: ''
    click_button 'Search'
    expect(page).not_to have_content(event.name)
  end
end
