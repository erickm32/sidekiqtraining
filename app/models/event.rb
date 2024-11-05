class Event < ApplicationRecord
  belongs_to :category

  validates :name, presence: true

  def self.permitted_attributes
    [ :name, :category_id, :timestamp, :observation ]
  end
end
