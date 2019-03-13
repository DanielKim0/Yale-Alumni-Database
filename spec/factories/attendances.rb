FactoryBot.define do
  factory :attendance do
    alumnus
    model
    description "Test Description"

    factory :attended, class: Attendance do
      alumnus.association(:event, name: "Event")
    end

    factory :attended_alum, parent: alumnus do
      after(:create), {|alumnus| create(:attended, alumnus: alumnus) }
    end
  end
end
