# --- Afficher le contenu de la base comme une migration
cat db/configuration | xargs sequel -d

# --- Une autre façon de faire, avec Bash
sequel -d $(cat db/configuration)

# --- Pareil, mais avec Fish
sequel -d (cat db/configuration)

# --- Création du dossier db/migrations
mkdir db/migrations

# --- Lancer la migration avec sequel
sequel -m db/migrations/ $(cat db/configuration)

# --- Lancer la migration en local
bundle exec rake db:migrate

# --- Lancer la migration sur Heroku
heroku run rake db:migrate

# --- Redémarrer une application sur Heroku
heroku restart
