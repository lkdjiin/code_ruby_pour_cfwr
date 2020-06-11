# ---
# Un début typique de Gemfile
source "https://rubygems.org/"

# ---
gem 'rack'

# ---
# Un premier Gemfile
# Fichier Gemfile
source "https://rubygems.org/"
gem 'rack'

# ---
# Charger les dépendances
# Fichier config.ru
require 'bundler/setup'
Bundler.require(:default)
# [...]

# ---
# Préciser la version de Ruby
# Fichier Gemfile
source "https://rubygems.org/"
ruby "2.7.1"
gem 'rack'

# ---
# Préciser la version d'une gem
# Fichier Gemfile
source "https://rubygems.org/"
ruby "2.7.1"
gem 'rack', '= 2.0.1'

# ---
# Inclure puma dans le Gemfile
# Fichier Gemfile
source "https://rubygems.org/"
ruby "2.7.1"
gem 'rack', '~> 2.2.0'
gem 'puma'
