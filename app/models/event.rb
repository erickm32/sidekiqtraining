class Event < ApplicationRecord
  belongs_to :category

  validates :name, presence: true

  enum :status, { pending: "pending", processing: "processing", processed: "processed", failed: "failed" }

  def self.permitted_attributes
    [ :id, :category_id, :name, :observation, :timestamp ]
  end
end
