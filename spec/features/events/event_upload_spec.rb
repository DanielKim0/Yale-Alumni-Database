require 'rails_helper'

RSpec.feature 'Events CSV Import' do
  it 'does not succeed' do
    visit new_event_path
    attach_file Rails.root.join('spec', 'fixtures', 'non_csv_events')
    click_on 'Import'
    expect(page).to have_content("File unsuccessfully uploaded")
    expect(Event.count).to eq(0)
  end

  it 'succeeds' do
    visit new_event_path
    attach_file Rails.root.join('spec', 'fixtures', 'valid_events.csv')
    click_on 'Import'
    expect(Event.count).to eq(2)
    expect(page).to have_content("File successfully uploaded")
  end
end
