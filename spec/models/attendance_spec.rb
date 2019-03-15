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

      it "is invalid without an alumnus" do
        expect(FactoryBot.build(:attendance, alumnus: nil).save).to be_falsey
      end

      it "is invalid without an event" do
        expect(FactoryBot.build(:attendance, event: nil).save).to be_falsey
      end
    end
  end

  context "when uploading csv" do
    before do
      Alumnus.import(fixture_file_upload(file_path('valid_alumni.csv'), 'text/csv'))
      Event.import(fixture_file_upload(file_path("valid_events.csv"), 'text/csv'))
    end

    it "does not accept a non-csv file" do
      file = fixture_file_upload(file_path('non_csv_attendances'))
      Attendance.import(file)
      expect(Attendance.find_by(event_id: 1)).to eq nil
    end

    it "does not accept invalid headers" do
      file = fixture_file_upload(file_path('invalid_header_attendances.csv'), 'text/csv')
      Attendance.import(file)
      expect(Attendance.find_by(event_id: 1)).to eq nil
    end

    it "saves a new attendance" do
      file = fixture_file_upload(file_path("valid_attendances.csv"), 'text/csv')
      Attendance.import(file)
      expect(Attendance.find_by(event_id: 2)).not_to eq nil
    end

    it "saves multiple new attendances" do
      file = fixture_file_upload(file_path('valid_attendances.csv'), 'text/csv')
      Attendance.import(file)
      expect(Attendance.find_by(event_id: 2)).not_to eq nil
    end

    it "does not save invalid attendances" do
      file = fixture_file_upload(file_path('invalid_attendances.csv'), 'text/csv')
      Attendance.import(file)
      expect(Attendance.find_by(event_id: 2)).to eq nil
    end
  end

  def file_path(filename)
    Rails.root.join('spec', 'fixtures', "#{filename}")
  end
end
