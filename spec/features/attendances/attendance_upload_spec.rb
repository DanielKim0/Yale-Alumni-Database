require 'rails_helper'

RSpec.feature 'Attendance CSV Import' do
  before do
    FactoryBot.create(:alumnus, :name => "Name One", :email => "name@one.com")
    FactoryBot.create(:alumnus, :name => "Name Two", :email => "name@two.com")
    FactoryBot.create(:event, :name => "Name One")
    FactoryBot.create(:event, :name => "Name Two")
  end

  it 'does not succeed' do
    visit new_attendance_path
    attach_file Rails.root.join('spec', 'fixtures', 'non_csv_attendances')
    click_on 'Import'
    expect(Attendance.count).to eq(0)
    expect(page).to have_content("File unsuccessfully uploaded")
  end

  it 'succeeds' do
    visit new_attendance_path
    attach_file Rails.root.join('spec', 'fixtures', 'valid_attendances.csv')
    click_on 'Import'
    expect(Attendance.count).to eq(2)
    expect(page).to have_content("File successfully uploaded")
  end
end
