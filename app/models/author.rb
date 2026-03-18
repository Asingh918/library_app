class Author < ApplicationRecord
  has_many :author_books
  has_many :books, through: :author_books
  validates :name, presence: true
  validates :ol_key, presence: true, uniqueness: true
end