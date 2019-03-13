FactoryBot.use_parent_strategy = false

FactoryBot.define do
  factory :attendance do
    alumnus
    event
    description {"Test Description"}
  end
end
