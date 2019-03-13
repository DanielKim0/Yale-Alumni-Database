require 'rails_helper'

RSpec.describe Attendance, type: :model do
  context "when creating" do
    before do
      @alumnus = FactoryBot.build(:alumnus)
      @event = FactoryBot.build(:event)
    end

    describe 'basic validations' do
      subject { build(:attendance) }

      it { is_expected.to belong_to(:event) }
      it { is_expected.to belong_to(:alumnus) }
    end

    describe 'other validations' do
      it "has a valid factory" do
        expect(FactoryBot.build(:attendance).save).to be_truthy
      end

      it "is invalid without a name" do
        expect(FactoryBot.build(:alumnus, name: nil).save).to be_falsey
      end
    end
  end

  context "when uploading csv" do
    it "does not accept a non-csv file" do
      file = fixture_file_upload(file_path('non_csv_alumni'))
      Alumnus.import(file)
      expect(Alumnus.find_by(name: 'Name One')).to eq nil
    end

    it "does not accept invalid headers" do
      file = fixture_file_upload(file_path('invalid_header_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(name: 'Name One')).to eq nil
    end

    it "saves a new alumni" do
      file = fixture_file_upload(file_path("valid_alumni.csv"), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(name: 'Name One').email).to eq "name@one.com"
    end

    it "saves multiple new alumni" do
      file = fixture_file_upload(file_path('valid_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(name: 'Name Two').email).to eq "name@two.com"
    end

    it "does not save invalid alumni" do
      file = fixture_file_upload(file_path('invalid_alumni.csv'), 'text/csv')
      Alumnus.import(file)
      expect(Alumnus.find_by(name: 'Name Two')).to eq nil
    end
  end

  def file_path(filename)
    Rails.root.join('spec', 'fixtures', "#{filename}")
  end
end
