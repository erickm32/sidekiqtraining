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
      it 'returns an empty array' do
        get api_events_path
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end

  describe "GET /api/events/:id" do
    context 'when there is an event with the id' do
      let(:event) { create(:event) }

      it 'returns the event as json' do
        get api_event_path(event)
        expect(JSON.parse(response.body)).to eq(event.as_json)
      end
    end

    context 'when the event id is invalid' do
      it 'returns an error' do
        get api_event_path(999)
        expect(JSON.parse(response.body)).to eq({ "error"=>"Couldn't find Event with 'id'=999" })
        expect(response.status).to eq(404)
      end
    end
  end

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
    context 'with valid params' do
      let(:event) { create(:event) }

      it 'updates the record' do
        patch api_event_path(event.id), params: { event: event_params.merge({ observation: 'new observation' }) }
        expect(response.status).to eq(200)
        event.reload
        expect(event.observation).to eq('new observation')
      end
    end

    context 'with invalid params' do
      let(:event) { create(:event) }

      it 'fails to update the record' do
        patch api_event_path(event.id), params: { event: event_params.merge({ observation: 'new observation', category_id: 999 }) }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({ "category"=>[ "must exist" ] })
        event.reload
        expect(event.observation).not_to eq('new observation')
      end
    end
  end

  describe "PUT /api/events/:id" do
    context 'with valid params' do
      let(:event) { create(:event) }

      it 'updates the record' do
        put api_event_path(event.id), params: { event: { observation: 'new observation' } }
        expect(response.status).to eq(200)
        event.reload
        expect(event.observation).to eq('new observation')
      end
    end

    context 'with invalid params' do
      let(:event) { create(:event) }

      it 'fails to update the record' do
        put api_event_path(event.id), params: { event: { observation: 'new observation', category_id: 999 } }
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({ "category"=>[ "must exist" ] })
        event.reload
        expect(event.observation).not_to eq('new observation')
      end
    end
  end

  describe "DELETE /api/events/:id" do
    context 'with correct params' do
      let!(:event) { create(:event) }

      it 'deletes successfully' do
        expect do
          delete api_event_path(event.id)
        end.to change(Event, :count).by(-1)
        expect(JSON.parse(response.body)).to eq(event.as_json)
      end
    end

    context 'with invalid params' do
      it 'raise an error' do
        delete api_event_path(999)
        expect(JSON.parse(response.body)).to eq({ "error"=>"Couldn't find Event with 'id'=999" })
        expect(response.status).to eq(404)
      end
    end
  end

  def event_params
    {
      category_id: Category.last.id || create(:category).id,
      name: 'Test name',
      observation: 'obs',
      timestamp: Time.now
    }
  end
end
