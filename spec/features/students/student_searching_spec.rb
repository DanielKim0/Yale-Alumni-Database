require "rails_helper"

RSpec.feature "user searches for students" do
  let(:student) {FactoryBot.create(:student, first_name: "AAA",
    last_name: "BBB", name: "AAA BBB", email: "other@email.com") }

  scenario "with a result" do
    visit students_path
    fill_in "search", with: student.name
    click_button 'Search'
    expect(page).to have_content(student.first_name)
    expect(page).to have_content(student.last_name)
  end

  scenario "without a result" do
    visit students_path
    fill_in 'search', with: 'Test'
    click_button 'Search'
    expect(page).not_to have_content(student.first_name)
    expect(page).not_to have_content(student.last_name)
  end

  scenario "with an empty search box" do
    visit students_path
    fill_in 'search', with: ''
    click_button 'Search'
    expect(page).not_to have_content(student.first_name)
    expect(page).not_to have_content(student.last_name)
  end
end
