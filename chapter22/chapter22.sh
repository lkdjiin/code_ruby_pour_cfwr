# --- Une appli toute neuve
cp -r chapter20 chapter22
rm -rf ch22test/{assets,controllers,db,logs,models,views}/*


# --- Lancer la migration
rake db:migrate


# --- Contenu du répertoire db
tree db


# --- Remplissage avec les données
sqlite3 -init db/seed.sql db/database.sqlite 


# --- Test de notre nouvelle appli
curl -is 'http://localhost:9292/quotes'


# --- Des données en JSON
curl -is 'http://localhost:9292/quotes/show?character=brett'


# --- Mise à jour des données
curl -X POST -is 'http://localhost:9292/quotes/like?id=5'


# --- On a rien cassé ?
curl -is 'http://localhost:9292/v1/quotes/show?character=yolanda'


# --- Passez votre chemin
curl 'http://localhost:9292/v1/boom'


# --- Badaboum
curl -is 'http://localhost:9292/v1/quotes/show?character=brett'
