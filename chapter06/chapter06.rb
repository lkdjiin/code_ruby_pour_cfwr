# ---
# Le mélange Ruby/SQL n'est pas du meilleur effet
sql = "INSERT INTO articles(name, quantity) VALUES(?, ?);"
db.execute(sql, ["Article 1", 12])

# ---
# Un article en Ruby
Article = Struct.new(:id, :name, :quantity)
Article.new(1, "tomate", 23)

# ---
# Un user en Ruby
User = Struct.new(:id, :fullname)
User.new(1, "xavier nayrac")

# ---
# Le nouveau Gemfile, avec la gem sequel
# Fichier Gemfile
source "https://rubygems.org/"
gem 'rack', '~> 2.0.1'
gem 'puma'
gem 'sqlite3', '~> 1.3.11'
gem 'sequel', '~> 4.43.0'

# ---
DB = Sequel.connect('sqlite://db/database.sqlite')

# ---
# Connexion à une base sqlite
require 'sequel'
DB = Sequel.connect('sqlite://db/database.sqlite')

# ---
# Création du modèle Article
class Article < Sequel::Model
end

# ---
# Obtenir tous les articles
Article.all

# ---
# Obtenir un article précis
Article[2]

# ---
# Les colonnes sont aussi des méthodes
Article.columns
article = Article[2]
article.id
article.name
article.quantity

# ---
# Modifier un article
article.quantity = 23
article

# ---
# Recharger un article depuis la base de données
article.reload

# ---
# Modifier et sauvegarder un article
article.quantity = 17
article.save
article.reload

# ---
# Chercher par une colonne
Article.where(name: "Courgette").all

# ---
# Chercher avec un bloc
Article.where{quantity > 15}.all

# ---
Article.where(Sequel.lit('quantity > ?', 15)).all

# ---
# Une syntaxe un peu particulière
DB[:articles].all
DB[:articles][id: 2]

# ---
# Ajout du modèle Article
# Fichier models/article.rb
class Article < Sequel::Model
end

# ---
# Connexion à la base de données dans notre framework
# Fichier lib/application.rb
# ...
DB = Sequel.connect('sqlite://db/database.sqlite')
# ...

# ---
# Chargement de tous les modèle au démarrage
# Fichier lib/application.rb
# ...
DB = Sequel.connect('sqlite://db/database.sqlite')
Dir.glob('models/*.rb') { |filename| require_relative("../#{filename}") }
# ...

# ---
# Un contrôleur pour les articles
# Fichier controllers/articles_controller.rb
class ArticlesController < BaseController
  def index
    articles = Article.all

    puts "-----------------------------------------------"
    p articles
    puts "-----------------------------------------------"
  end
end

# ---
# Maintenant c'est vraiment votre dernière chance…
# Fichier controllers/articles_controller.rb
class ArticlesController < BaseController
  def index
    articles = Article.all

    puts "-----------------------------------------------"
    p articles
    puts "-----------------------------------------------"

    [200, {}, ["et voici la solution"]]
  end
end


