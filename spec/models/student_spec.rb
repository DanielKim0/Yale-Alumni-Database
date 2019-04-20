require 'rails_helper'

RSpec.describe Student, type: :model do
  context "when creating" do
    describe 'basic validations' do
      subject { build(:student) }

      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    end

    describe 'other validations' do
      it "has a valid factory" do
        expect(FactoryBot.build(:student).save).to be_truthy
      end

      it "is invalid without a first name" do
        expect(FactoryBot.build(:student, first_name: nil, last_name: "A").save).to be_falsey
      end

      it "is invalid without a last name" do
        expect(FactoryBot.build(:student, first_name: "B", last_name: nil).save).to be_falsey
      end

      it "is invalid with a whitespace name" do
        expect(FactoryBot.build(:student, first_name: "    ", last_name: "    ").save).to be_falsey
      end

      it "is valid even without a unique name" do
        student = FactoryBot.create(:student)
        expect(FactoryBot.build(:student, email: "different@email.com").save).to be_truthy
      end

      it "is invalid without an email" do
        expect(FactoryBot.build(:student, email: nil).save).to be_falsey
      end

      it "is invalid without a unique email" do
        student = FactoryBot.create(:student)
        expect(FactoryBot.build(:student, first_name: "Different", last_name: "Name").save).to be_falsey
      end

      it "should save email as lowercase" do
        mixed_case_email = "TEST@test.TeSt"
        student = FactoryBot.create(:student, email: mixed_case_email)
        expect(student.email).to eq(mixed_case_email.downcase)
      end

      it "is invalid without a unique lowercase email" do
        mixed_case_email = "TEST@test.TeSt"
        student = FactoryBot.create(:student)
        expect(FactoryBot.build(:student, email: mixed_case_email).save).to be_falsey
      end

      it "is invalid with a whitespace email" do
        expect(FactoryBot.build(:student, email: "    ").save).to be_falsey
      end

      it "is invalid without a correctly-formatted email" do
        expect(FactoryBot.build(:student, email: "abcd").save).to be_falsey
      end
    end
  end

  context "when updating" do
    describe "when valid" do
      it "successfully updates first name" do
        student = FactoryBot.create(:student)
        student.update(first_name: "Other")
        expect(student.first_name).to eq("Other")
      end

      it "successfully updates first name" do
        student = FactoryBot.create(:student)
        student.update(last_name: "Other")
        expect(student.last_name).to eq("Other")
      end

      it "successfully updates email" do
        student = FactoryBot.create(:student)
        student.update(email: "other@email.com")
        expect(student.email).to eq("other@email.com")
      end
    end

    describe "when not valid" do
      let!(:student) { FactoryBot.create(:student) }
      let!(:other) {FactoryBot.create(:student, first_name: "Other",
        last_name: "Name", email: "other@email.com") }

      it "is invalid without a unique, case-insensitive email" do
        mixed_case_email = "OTHER@email.CoM"
        expect(student.update(email: mixed_case_email)).to be_falsey
      end
    end
  end

  context "when searching" do
    it "finds a searched-for student by name" do
      student = FactoryBot.create(:student)
      result = Student.search(search: "#{student.first_name} #{student.last_name}")
      expect(result).to eq([student])
    end

    it "does not find an student with a different name" do
      student = FactoryBot.create(:student)
      result = Student.search(search: "Different Name")
      expect(result).not_to eq([student])
    end

    it "finds multiple students with the same name" do
      student_1 = FactoryBot.create(:student)
      student_2 = FactoryBot.create(:student, email: "different@different.com")
      result = Student.search(search: "#{student_1.first_name} #{student_1.last_name}")
      expect(result.length).to eq(2)
    end

    it "lists students in reverse order of creation" do
      student_1 = FactoryBot.create(:student)
      student_2 = FactoryBot.create(:student, email: "different@different.com")
      result = Student.search(search: "#{student_1.first_name} #{student_1.last_name}")
      expect(result).to eq([student_2, student_1])
    end
  end

  context "when deleting" do
    it "deletes the resource" do
      student = FactoryBot.create(:student)
      expect { student.destroy }.to change { Student.count }
    end
  end

  context "when uploading csv" do
    it "does not accept a non-csv file" do
      file = fixture_file_upload(file_path('non_csv_students'))
      Student.import(file)
      expect(Student.find_by(last_name: 'One')).to eq nil
    end

    it "does not accept invalid headers" do
      file = fixture_file_upload(file_path('invalid_header_students.csv'), 'text/csv')
      Student.import(file)
      expect(Student.find_by(last_name: 'One')).to eq nil
    end

    it "saves a new students" do
      file = fixture_file_upload(file_path("valid_students.csv"), 'text/csv')
      Student.import(file)
      expect(Student.find_by(last_name: 'One').email).to eq "name@one.com"
    end

    it "saves multiple new students" do
      file = fixture_file_upload(file_path('valid_students.csv'), 'text/csv')
      Student.import(file)
      expect(Student.find_by(last_name: 'Two').email).to eq "name@two.com"
    end

    it "does not save invalid students" do
      file = fixture_file_upload(file_path('invalid_students.csv'), 'text/csv')
      Student.import(file)
      expect(Student.find_by(last_name: 'Two')).to eq nil
    end
  end

  def file_path(filename)
    Rails.root.join('spec', 'fixtures', "#{filename}")
  end
end
