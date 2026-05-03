class AddStatusAndProcessedAtToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :status, :string, default: "pending", null: false
    add_column :events, :processed_at, :datetime
  end
end
