# ---
bundle

# ---
# Installer la gem bundle
gem install bundler

# ---
cat Gemfile.lock 

# ---
# Erreur due à une version d
rackup
#=> Your Ruby version is 2.3.3, but your Gemfile specified 2.4.0

# ---
# Recherche naïve
gem search rack

# ---
# Un peu trop de résultat
gem search rack | wc -l

# ---
# Une recherche plus pratique
gem search ^rack$
