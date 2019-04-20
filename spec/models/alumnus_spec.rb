require 'rails_helper'

RSpec.describe Alumnus, type: :model do
  context "when creating" do
    describe 'basic validations' do
      subject { build(:alumnus) }

      it { is_expected.to validate_presence_of(:first_name) }
      it { is_expected.to validate_presence_of(:last_name) }
      it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
      it { is_expected.to have_many(:attendances) }
    end

    describe 'other validations' do
      it "has a valid factory" do
        expect(FactoryBot.build(:alumnus).save).to be_truthy
      end

      it "is invalid without a first name" do
        expect(FactoryBot.build(:alumnus, first_name: nil, last_name: "A").save).to be_falsey
      end

      it "is invalid without a last name" do
        expect(FactoryBot.build(:alumnus, first_name: "B", last_name: nil).save).to be_falsey
      end

      it "is invalid with a whitespace name" do
        expect(FactoryBot.build(:alumnus, first_name: "    ", last_name: "    ").save).to be_falsey
      end

      it "is valid even without a unique name" do
        alumnus = FactoryBot.create(:alumnus)
        expect(FactoryBot.build(:alumnus, email: "different@email.com").save).to be_truthy
      end

      it "is invalid without an email" do
        expect(FactoryBot.build(:alumnus, email: nil).save).to be_falsey
      end

      it "is invalid without a unique email" do
        alumnus = FactoryBot.create(:alumnus)
        expect(FactoryBot.build(:alumnus, first_name: "Different", last_name: "Name").save).to be_falsey
      end

      it "should save email as lowercase" do
        mixed_case_email = "TEST@test.TeSt"
        alumnus = FactoryBot.create(:alumnus, email: mixed_case_email)
        expect(alumnus.email).to eq(mixed_case_email.downcase)
      end

      it "is invalid without a unique lowercase email" do
        mixed_case_email = "TEST@test.TeSt"
        alumnus = FactoryBot.create(:alumnus)
        expect(FactoryBot.build(:alumnus, email: mixed_case_email).save).to be_falsey
      end

      it "is invalid with a whitespace email" do
        expect(FactoryBot.build(:alumnus, email: "    ").save).to be_falsey
      end

      it "is invalid without a correctly-formatted email" do
        expect(FactoryBot.build(:alumnus, email: "abcd").save).to be_falsey
      end
    end
  end

  context "when updating" do
    describe "when valid" do
      it "successfully updates first name" do
        alumnus = FactoryBot.create(:alumnus)
        alumnus.update(first_name: "Other")
        expect(alumnus.first_name).to eq("Other")
      end

      it "successfully updates first name" do
        alumnus = FactoryBot.create(:alumnus)
        alumnus.update(last_name: "Other")
        expect(alumnus.last_name).to eq("Other")
      end

      it "successfully updates email" do
        alumnus = FactoryBot.create(:alumnus)
        alumnus.update(email: "other@email.com")
        expect(alumnus.email).to eq("other@email.com")
      end
    end

    describe "when not unique" do
      let!(:alumnus) { FactoryBot.create(:alumnus) }
      let!(:other) {FactoryBot.create(:alumnus, first_name: "Other",
        last_name: "Name", email: "other@email.com") }

      it "is invalid without a unique, case-insensitive email" do
        mixed_case_email = "OTHER@email.CoM"
        expect(alumnus.update(email: mixed_case_email)).to be_falsey
      end
    end
  end

  context "when searching" do
    it "finds a searched-for alumnus by full name" do
      alumnus = FactoryBot.create(:alumnus)
      result = Alumnus.search(search: "#{alumnus.first_name} #{alumnus.last_name}")
      expect(result).to eq([alumnus])
    end

    it "does not find an alumnus with a different name" do
      alumnus = FactoryBot.create(:alumnus)
      result = Alumnus.search(search: "Different Name")
      expect(result).not_to eq([alumnus])
    end

    it "finds multiple alumni with the same name" do
      alumnus_1 = FactoryBot.create(:alumnus)
      alumnus_2 = FactoryBot.create(:alumnus, email: "different@different.com")
      result = Alumnus.search(search: "#{alumnus_1.first_name} #{alumnus_1.last_name}")
      expect(result.length).to eq(2)
    end

    it "lists alumni in reverse order of creation" do
      alumnus_1 = FactoryBot.create(:alumnus)
      alumnus_2 = FactoryBot.create(:alumnus, email: "different@different.com")
      result = Alumnus.search(search: "#{alumnus_1.first_name} #{alumnus_1.last_name}")
      expect(result).to eq([alumnus_2, alumnus_1])
    end
  end

  context "when deleting" do
    it "deletes the resource" do
      alumnus = FactoryBot.create(:alumnus)
      expect { alumnus.destroy }.to change { Alumnus.count }
    end

    it "destroys attendances" do
      attendance = FactoryBot.create(:attendance)
      expect { attendance.alumnus.destroy! }.to change { Attendance.count }
    end

    it "does not destroy connected events" do
      attendance = FactoryBot.create(:attendance)
      expect { attendance.alumnus.destroy! }.not_to change { Event.count }
    end
  end

  context "when uploading csv" do
    it "does not accept a non-csv file" do
      file = fixture_file_upload(file_path('non_csv_alumni'))
      Alumnus.import(file)
      expect(Alumnus.find_by(last_name: 'One')).to eq nil
    end

    it "does not accept invalid headers" do
      file = fixture_file_upload(file_path('invalid_header_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(last_name: 'One')).to eq nil
    end

    it "saves a new alumni" do
      file = fixture_file_upload(file_path("valid_alumni.csv"), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(last_name: 'One').email).to eq "name@one.com"
    end

    it "saves multiple new alumni" do
      file = fixture_file_upload(file_path('valid_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(last_name: 'Two').email).to eq "name@two.com"
    end

    it "does not save invalid alumni" do
      file = fixture_file_upload(file_path('invalid_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(last_name: 'Two')).to eq nil
    end
  end

  def file_path(filename)
    Rails.root.join('spec', 'fixtures', "#{filename}")
  end
end
