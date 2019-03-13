FactoryBot.define do
  factory :alumnus, class: Alumnus do
    name {"Test Name"}
    email {"test@test.test"}

    factory :alumnus_with_attendances do
      transient do
        attendances_count { 5 }
      end
      after(:create) do |alumnus, evaluator|
        create_list(:attendance, evaluator.attendance_count, alumnus: alumnus)
      end
    end
  end
end
