require 'rails_helper'

RSpec.describe Attendance, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:attended_alum).save).to be_true
  end

  it "needs an alumnus" do
    expect(FactoryBot.build(:attended).save).to be_false
  end

  it "needs an event" do
    expect(FactoryBot).build(:attended_alum, event: nil).to be_false
  end
end
