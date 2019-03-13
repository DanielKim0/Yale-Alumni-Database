require 'rails_helper'

RSpec.describe Event, type: :model do
  context "when creating" do
    describe 'basic validations' do
      subject { build(:event) }
      it { is_expected.to validate_uniqueness_of(:name) }
    end

    describe 'other validations' do
      it "has a valid factory" do
        expect(FactoryBot.build(:event).save).to be_truthy
      end

      it "is invalid without a name" do
        expect(FactoryBot.build(:event, name: nil).save).to be_falsey
      end

      it "is invalid with a whitespace name" do
        expect(FactoryBot.build(:event, name: "    ").save).to be_falsey
      end

      it "is valid even without a unique name" do
        event = FactoryBot.create(:event)
        expect(FactoryBot.build(:event).save).to be_falsey
      end
    end
  end

  context "when updating" do
    describe "when valid" do
      it "successfully updates name" do
        event = FactoryBot.create(:event)
        event.update(name: "Other Name")
        expect(event.name).to eq("Other Name")
      end
    end

    describe "when not valid" do
      let!(:event) { FactoryBot.create(:event) }
      let!(:other) {FactoryBot.create(:event, name: "Other Name") }

      it "is invalid without a name" do
        expect(event.update(name: nil)).to be_falsey
      end

      it "is invalid with a whitespace name" do
        expect(event.update(name: "    ")).to be_falsey
      end

      it "is invalid without a unique name" do
        expect(event.update(name: "Other Name")).to be_falsey
      end
    end
  end

  context "when searching" do
    it "finds a searched-for event by name" do
      event = FactoryBot.create(:event)
      result = Event.search(search: event.name)
      expect(result).to eq([event])
    end

    it "does not find an event with a different name" do
      event = FactoryBot.create(:event)
      result = Event.search(search: "Different Name")
      expect(result).not_to eq([event])
    end
  end

  context "when deleting" do
    it "deletes the resource" do
      event = FactoryBot.create(:event)
      expect { event.destroy }.to change { Event.count }
    end

    it "destroys attendances" do
      attendance = FactoryBot.create(:attendance)
      expect { attendance.event.destroy! }.to change { Attendance.count }
    end

    it "does not destroy connected events" do
      attendance = FactoryBot.create(:attendance)
      expect { attendance.event.destroy! }.not_to change { Alumnus.count }
    end
  end

  context "when uploading csv" do
    it "does not accept a non-csv file" do
      file = fixture_file_upload(file_path('non_csv_events'))
      Event.import(file)
      expect(Event.find_by(name: 'Name One')).to eq nil
    end

    it "does not accept invalid headers" do
      file = fixture_file_upload(file_path('invalid_header_events.csv'), 'text/csv')
      Event.import(file)
      expect(Event.find_by(name: 'Name One')).to eq nil
    end

    it "saves a new events" do
      file = fixture_file_upload(file_path("valid_events.csv"), 'text/csv')
      Event.import(file)
      expect(Event.find_by(name: 'Name One')).not_to eq nil
    end

    it "saves multiple new events" do
      file = fixture_file_upload(file_path('valid_events.csv'), 'text/csv')
      Event.import(file)
      expect(Event.find_by(name: 'Name Two')).not_to eq nil
    end

    it "does not save invalid events" do
      file = fixture_file_upload(file_path('invalid_events.csv'), 'text/csv')
      Event.import(file)
      expect(Event.find_by(name: 'Name Two')).to eq nil
    end
  end

  def file_path(filename)
    Rails.root.join('spec', 'fixtures', "#{filename}")
  end
end
