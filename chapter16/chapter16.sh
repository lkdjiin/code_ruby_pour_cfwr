# --- Initialisation du projet Git
git init

# --- Ajouter le dépot distant Heroku
heroku git:remote -a enigmatic-caverns-35140

# --- Enregistrer les modifications du Gemfile
bundle
git add .
git commit 'Update Gemfile'

# --- Encore un enregistrement dans Git
git add .
git commit 'Use Heroku database env if any'

# --- Envoyer le code sur Heroku
git push heroku master

# --- Afficher les logs
heroku logs

# --- Connexion à un serveur Postgresql distant
psql -h ec2-79-125-125-97.eu-west-1.compute.amazonaws.com -p 5432 -U pbrcebeepfshku deof5u804shuuh
