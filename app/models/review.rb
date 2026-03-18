class Review < ApplicationRecord
  belongs_to :book
  validates :body, presence: true
  validates :score, inclusion: { in: 1..5 }
  validates :reviewer_name, presence: true
end