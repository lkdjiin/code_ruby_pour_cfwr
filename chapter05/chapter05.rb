# ---
# Ajoutez sqlite3 dans le Gemfile
# Fichier Gemfile
# [...]
gem 'sqlite3'

# ---
require 'sqlite3'

# ---
db = SQLite3::Database.new("db/database.sqlite")

# ---
sql = "CREATE TABLE articles(id INTEGER PRIMARY KEY, name TEXT, quantity INTEGER);"
db.execute(sql)

# ---
sql = "INSERT INTO articles(name, quantity) VALUES(?, ?);"
db.execute(sql, ["Article 1", 12])

# ---
db.execute(sql, ["Article 2", 34])
db.execute(sql, ["Article 3", 9])

# ---
db.execute("SELECT * FROM articles;")

# ---
db.results_as_hash = true
db.execute("SELECT * FROM articles;")

# ---
db.execute("SELECT * FROM articles;") do |row|
  p row
end
