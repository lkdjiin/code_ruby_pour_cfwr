# --- Un dossier pour les générateurs
mkdir lib/generators


# --- La ligne de commande
bundle exec rake create:controller[world]


# --- Certains shells n'apprécient pas les crochets
bundle exec rake 'create:controller[world]'


# --- Pas mal…
bundle exec rake create:controller[articles]


# --- Un fichier pour le contrôleur
bundle exec rake create:controller[articles]
ls controllers/


# --- Plusieurs arguments sur la ligne de commande
bundle exec rake create:controller[foo,bar,baz]


# --- Petit pas de danse
bundle exec rake create:controller[vincent_vega,dance]
cat controllers/vincent_vega_controller.rb 
