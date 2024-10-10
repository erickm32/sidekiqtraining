class Category < ApplicationRecord
  has_many :events

  validates :name, presence: true

  def self.permitted_attributes
    [ :name ]
  end
end
