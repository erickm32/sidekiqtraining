class AddingObservationAndTimestampToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :timestamp, :datetime
    add_column :events, :observation, :text, default: ''
  end
end
