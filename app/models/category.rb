class Category < ApplicationRecord
  has_many :events, dependent: :restrict_with_error

  validates :name, presence: true

  def self.permitted_attributes
    [ :name ]
  end
end
