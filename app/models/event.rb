class Event < ApplicationRecord
  belongs_to :category

  validates :name, presence: true

  def self.permitted_attributes
    [ :id, :category_id, :name, :observation, :timestamp ]
  end
end
