class Book < ApplicationRecord
  belongs_to :subject
  has_many :author_books
  has_many :authors, through: :author_books
  has_many :reviews
  validates :title, presence: true
  validates :ol_key, presence: true, uniqueness: true
end