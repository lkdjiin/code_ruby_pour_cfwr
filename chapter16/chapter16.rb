# --- Nouveau code de connexion
# Fichier lib/application.rb
DB = Sequel.connect(ENV["DATABASE_URL"] || File.read("db/configuration").chomp)
