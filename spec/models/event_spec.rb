require 'rails_helper'

FactoryBot.define do
  factory :event do
    name "Test Name"
  end
end

RSpec.describe Event, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:event).save).to be_true
  end

  it "is invalid without a name" do
    expect(FactoryBot.build(:event, name: nil).save).to be_false
  end

  it "is invalid with a whitespace name" do
    expect(FactoryBot.build(:event, name: "    ").save).to be_false
  end

  it "is invalid without a unique name" do
    user = FactoryBot.create(:event)
    expect(FactoryBot.build(:event)).to be_false
  end
end
