require 'rails_helper'

RSpec.describe EventProcessorJob, type: :job do
  describe '#perform' do
    let(:event) { create(:event) }

    it 'transitions status from pending to processed' do
      expect { described_class.perform_now(event.id) }
        .to change { event.reload.status }.from('pending').to('processed')
    end

    it 'sets processed_at' do
      expect { described_class.perform_now(event.id) }
        .to change { event.reload.processed_at }.from(nil)
    end

    it 'does not raise when event is not found' do
      expect { described_class.perform_now(999) }.not_to raise_error
    end
  end
end
