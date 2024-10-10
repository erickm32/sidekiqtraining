require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /api/events" do
    context 'when there are events' do
      before do
        5.times { create(:event) }
      end

      it 'returns all the events in json' do
        get api_events_path
        expect(JSON.parse(response.body)).to eq(Event.all.as_json)
      end
    end
    context 'when there are no events' do
      it 'returns something' do
        get api_events_path
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
  describe "GET /api/events/:id" do
  end
  # describe "GET /index/new" do
  # end
  # describe "GET /index/edit" do
  # end
  describe "POST /api/events" do
    context 'with correct params' do
      let(:category) { create(:category) }

      it 'creates a new event' do
        expect do
          post api_events_path, params: { event: { name: 'New Event', category_id: category.id } }
        end.to change(Event, :count).by(1)
        expect(JSON.parse(response.body)).to eq(Event.last.as_json)
      end
    end

    context 'without correct params' do
      it 'returns an array with the errors' do
        expect do
          post api_events_path, params: { event: { name: nil } }
        end.to change(Event, :count).by(0)
        expect(JSON.parse(response.body)).to eq('name' => [ "can't be blank" ], 'category' => [ 'must exist' ])
      end
    end
  end
  describe "PATCH /api/events/:id" do
  end
  describe "PUT /api/events/:id" do
  end
  describe "DELETE /api/events/:id" do
  end
end
