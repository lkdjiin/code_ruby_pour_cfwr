# ---
# On fait un bundle comme d'habitude
bundle

# ---
# Lancer la console sequel
sequel sqlite://db/database.sqlite

# ---
cp -r ch05 ch06
cd ch06
rm controllers/*.rb
rm views/*.html
mkdir models


