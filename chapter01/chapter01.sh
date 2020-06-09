# ---
# Installer le programme rack
gem install rack

# ---
# Lancer le programme rack avec la commande rackup
rackup

# ---
# Lancer le programme rack avec un serveur web précis
rackup -swebrick

# ---
# Lancer le programme rack avec un port précis
rackup -swebrick -p9999

# ---
# Installer la gem awesome_print, vous ne le regreterez pas
gem install amazing_print

# ---
# Utiliser curl pour envoyer une requête
curl -i localhost:9292

# ---
# Le fichier config.ru peut se mettre où vous voulez
rackup my_folder/config.ru
