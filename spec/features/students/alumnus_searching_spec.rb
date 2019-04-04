require "rails_helper"

RSpec.feature "user searches for students" do
  let(:student) {FactoryBot.create(:student) }
  scenario "with a result" do
    visit students_path
    fill_in "search", with: student.name
    click_button 'Search'
    expect(page).to have_content(student.name)
  end

  scenario "without a result" do
    visit students_path
    fill_in 'search', with: 'Test'
    click_button 'Search'
    expect(page).not_to have_content(student.name)
  end

  scenario "with an empty search box" do
    visit students_path
    fill_in 'search', with: ''
    click_button 'Search'
    expect(page).not_to have_content(student.name)
  end
end
