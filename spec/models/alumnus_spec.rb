require 'rails_helper'

RSpec.describe Alumnus, type: :model do
  describe 'basic validations' do
    subject { build(:alumnus) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to have_many(:attendances) }
  end

  describe 'other validations' do

    it "has a valid factory" do
      expect(FactoryBot.build(:alumnus).save).to be_truthy
    end

    it "is invalid without a name" do
      expect(FactoryBot.build(:alumnus, name: nil).save).to be_falsey
    end

    it "is invalid with a whitespace name" do
      expect(FactoryBot.build(:alumnus, name: "    ").save).to be_falsey
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
      expect(FactoryBot.build(:alumnus, name: "Different Name").save).to be_falsey
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

  context "when searching" do
    it "finds a searched-for alumnus by name" do
      alumnus = FactoryBot.create(:alumnus)
      result = Alumnus.search(search: alumnus.name)
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
      result = Alumnus.search(search: alumnus_1.name)
      expect(result.length).to eq(2)
    end

    it "lists alumni in reverse order of creation" do
      alumnus_1 = FactoryBot.create(:alumnus)
      alumnus_2 = FactoryBot.create(:alumnus, email: "different@different.com")
      result = Alumnus.search(search: alumnus_1.name)
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
      let(:file) { fixture_file_upload('files/non_csv_alumni.xml') }
      Alumnus.import(:file)
      expect(Alumnus.find_by(name: 'One Name').email).not_to eq "one@email.com"
    end

    it "does not accept invalid headers" do
      let(:file) { fixture_file_upload('files/invalid_header_alumni.csv') }
      Alumnus.import(:file)
      expect(Alumnus.find_by(name: 'One Name').email).not_to eq "one@email.com"
    end

    it "saves a new alumni" do
      let(:file) { fixture_file_upload('files/valid_alumni.csv') }
      Alumnus.import(:file)
      expect(Alumnus.find_by(name: 'One Name').email).to eq "one@email.com"
    end

    it "saves multiple new alumni" do
      let(:file) { fixture_file_upload('files/valid_alumni.csv') }
      Alumnus.import(:file)
      expect(Alumnus.find_by(name: 'Two Name').email).to eq "two@email.com"
    end

    it "does not save invalid alumni" do
      let(:file) { fixture_file_upload('files/invalid_alumni.csv') }
      Alumnus.import(:file)
      expect(Alumnus.find_by(name: 'Two Name').email).not_to eq "two@email.com"
    end
  end
end
