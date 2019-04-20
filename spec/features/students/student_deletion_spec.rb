require "rails_helper"

RSpec.feature "user deletes students" do
  before(:each) do
    @student = FactoryBot.create(:student)
  end

  scenario "successfully, from student page" do
    visit student_path(@student)
    click_button "delete"
    expect(Student.count).to eq(0)
  end

  scenario "successfully, from students index" do
    visit students_path
    click_button "delete"
    expect(Student.count).to eq(0)
  end
end
