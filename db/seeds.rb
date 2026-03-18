require 'httparty'
require 'csv'

# ============================================
# SOURCE 1 — CSV: Load subjects
# ============================================
puts "Loading subjects from CSV..."
CSV.foreach(Rails.root.join('db', 'subjects.csv'), headers: true) do |row|
  Subject.find_or_create_by(name: row['name'])
end
puts "Subjects done: #{Subject.count}"

# ============================================
# SOURCE 2 — Open Library API: Books & Authors
# ============================================
puts "Fetching books from Open Library API..."

subjects = ['science_fiction', 'mystery', 'fantasy', 'biography', 'horror']

subjects.each do |subject_name|
  puts "  Fetching: #{subject_name}..."

  response = HTTParty.get(
    "https://openlibrary.org/subjects/#{subject_name}.json?limit=40"
  )

  next unless response.success?

  data = JSON.parse(response.body)
  works = data['works'] || []

  display_name = subject_name.gsub('_', ' ').titleize
  db_subject = Subject.find_or_create_by(name: display_name)

  works.each do |work|
    next if work['key'].blank? || work['title'].blank?

    cover_id = work['cover_id']
    cover_url = cover_id ? "https://covers.openlibrary.org/b/id/#{cover_id}-M.jpg" : nil

    book = Book.find_or_create_by(ol_key: work['key']) do |b|
      b.title = work['title']
      b.first_publish_year = work['first_publish_year']
      b.cover_url = cover_url
      b.subject = db_subject
    end

    next unless book.persisted?

    (work['authors'] || []).each do |a|
      next if a['key'].blank? || a['name'].blank?

      author = Author.find_or_create_by(ol_key: a['key']) do |au|
        au.name = a['name']
        au.bio = "Author of #{work['title']}"
        au.birth_date = "Unknown"
      end

      if author.persisted?
        AuthorBook.find_or_create_by(book: book, author: author)
      end
    end
  end

  sleep(0.5)
end

puts "Books done: #{Book.count}"
puts "Authors done: #{Author.count}"

# ============================================
# SOURCE 3 — Faker: Generate reviews
# ============================================
puts "Generating fake reviews with Faker..."

Book.all.each do |book|
  3.times do
    Review.create(
      body: Faker::Lorem.paragraph(sentence_count: 3),
      reviewer_name: Faker::Name.name,
      score: rand(1..5),
      book: book
    )
  end
end

puts "Reviews done: #{Review.count}"
puts ""
puts "===== SEED COMPLETE ====="
puts "Subjects : #{Subject.count}"
puts "Books    : #{Book.count}"
puts "Authors  : #{Author.count}"
puts "Reviews  : #{Review.count}"
puts "Total rows: #{Subject.count + Book.count + Author.count + Review.count + AuthorBook.count}"