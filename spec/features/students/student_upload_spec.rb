require 'rails_helper'

RSpec.feature 'Student CSV Import' do
  it 'does not succeed' do
    visit new_student_path
    attach_file Rails.root.join('spec', 'fixtures', 'non_csv_students')
    click_on 'Import'
    expect(page).to have_content("File unsuccessfully uploaded")
    expect(Student.count).to eq(0)
  end

  it 'succeeds' do
    visit new_student_path
    attach_file Rails.root.join('spec', 'fixtures', 'valid_students.csv')
    click_on 'Import'
    expect(Student.count).to eq(2)
    expect(page).to have_content("File successfully uploaded")
  end
end
