# --- Puma, en mode «development» par défaut
bundle exec rackup


# --- 1ère partie du test
curl 'http://localhost:9292/v1/test'


# --- Puma en mode «production»
bundle exec rackup -E production


# --- Contenu du dossier db
ls db/{data,conf}*


# --- Contenu de css.yml
cat assets/css/css.yml 


# --- Un de moins
rm assets/css/full.css


# --- Une nouvelle tâche
RACK_ENV=production bundle exec rake css:compile


# --- La vérification
rm assets/css/full.css
RACK_ENV=production bundle exec rake css:compile
cat assets/css/full.css 
