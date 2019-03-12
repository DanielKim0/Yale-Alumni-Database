require 'rails_helper'

FactoryBot.define do
  factory :attendance do
    alumnus
    model
    description "Test Description"
  end

  factory :attended, class: Attendance do
    alumnus.association(:event, name: "Event")
  end

  factory :attended_alum, parent: alumnus do
    after(:create), {|alumnus| create(:attended, alumnus: alumnus) }
  end
end

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
