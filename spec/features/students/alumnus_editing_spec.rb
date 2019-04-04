require "rails_helper"

RSpec.feature "user edits students" do
  let(:student) { FactoryBot.create(:student) }

  scenario "with valid data" do
    visit edit_student_path(student)
    fill_in "Name", with: "Sample Name"
    fill_in "Email", with: "sample@email.com"
    click_button "Edit Student Record"

    expect(page).to have_content("Student updated.")
  end

  scenario "with invalid data" do
    visit edit_student_path(student)
    fill_in "Name", with: "Sample Name"
    fill_in "Email", with: ""
    click_button "Edit Student Record"

    expect(page).to have_content("Email can't be blank")
  end
end
