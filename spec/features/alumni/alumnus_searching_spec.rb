require "rails_helper"

RSpec.feature "user searches for alumni" do
  let(:alumnus) {FactoryBot.create(:alumnus) }
  scenario "with a result" do
    visit alumni_path
    fill_in "search", with: alumnus.name
    click_button 'Search'
    expect(page).to have_content(alumnus.name)
  end

  scenario "without a result" do
    visit alumni_path
    fill_in 'search', with: 'Test'
    click_button 'Search'
    expect(page).not_to have_content(alumnus.name)
  end

  scenario "with an empty search box" do
    visit alumni_path
    fill_in 'search', with: ''
    click_button 'Search'
    expect(page).not_to have_content(alumnus.name)
  end
end
