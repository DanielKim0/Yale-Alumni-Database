require "rails_helper"

RSpec.feature "user deletes alumni" do
  before(:each) do
    @alumnus = FactoryBot.create(:alumnus)
  end

  scenario "successfully, from alumnus page" do
    visit alumnus_path(@alumnus)
    click_link "delete"
    expect(Alumnus.count).to eq(0)
  end

  scenario "successfully, from alumni index" do
    visit alumni_path
    click_link "delete"
    expect(Alumnus.count).to eq(0)
  end
end
