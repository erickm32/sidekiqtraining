require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe 'factory' do
    it 'is valid' do
      expect(build(:event)).to be_valid
    end
  end

  describe 'defaults' do
    it 'sets observation to empty string by default' do
      event = create(:event)
      expect(event.observation).to eq("")
    end
  end

  describe '.permitted_attributes' do
    it 'returns the allowed attributes' do
      expect(Event.permitted_attributes).to match_array([:id, :category_id, :name, :observation, :timestamp])
    end
  end

  describe 'invalid cases' do
    it 'is invalid without a name' do
      event = build(:event, name: nil)
      expect(event).not_to be_valid
      expect(event.errors[:name]).to be_present
    end

    it 'is invalid without a category' do
      event = build(:event, category: nil)
      expect(event).not_to be_valid
      expect(event.errors[:category]).to be_present
    end
  end
end