require 'rails_helper'

RSpec.feature 'Alumnus CSV Import' do
  it 'does not succeed' do
    visit new_alumnus_path
    attach_file Rails.root.join('spec', 'fixtures', 'non_csv_alumni')
    click_on 'Import'
    expect(page).to have_content("File unsuccessfully uploaded")
    expect(Alumnus.count).to eq(0)
  end

  it 'succeeds' do
    visit new_alumnus_path
    attach_file Rails.root.join('spec', 'fixtures', 'valid_alumni.csv')
    click_on 'Import'
    expect(Alumnus.count).to eq(2)
    expect(page).to have_content("File successfully uploaded")
  end
end
