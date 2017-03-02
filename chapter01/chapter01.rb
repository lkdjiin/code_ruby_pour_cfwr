# -------
# Une première application Rack
# Fichier config.ru
class Application
  def call(env)
    [200, {}, ["Bonjour le monde !"]]
  end
end

run Application.new

# -------
object = Proc.new { 2 + 3 }
object.call
#=> 5

# -------
object = Proc.new {|n| n + 3 }
object.call(7)
#=> 10

# -------
# Notre application utilisant Proc
# Fichier config.ru
run Proc.new {|env| [200, {}, ["Bonjour le monde !"]] }

# -------
# Notre application utilisant une lambda
# Fichier config.ru
run ->(env) { [200, {}, ["Bonjour le monde !"]] }

# -------
# Une application vraiment bidon pour les besoins de la cause
# Fichier config.ru
run Object.new

# -------
# Afficher le hash env pour savoir ce qu'il contient
# Fichier config.ru
class Application
  def call(env)
    puts env
    [200, {}, ["Bonjour le monde !"]]
  end
end

run Application.new

# -------
# Cette fois ci vous y verrez mieux",lang=ruby}
# Fichier config.ru
require 'awesome_print'

class Application
  def call(env)
    ap env
    [200, {}, ["Bonjour le monde !"]]
  end
end

run Application.new

# -------
# La classe Array et la méthode each
["hamburger", "cheesburger"].each do |element|
  puts element
end
#=> hamburger
#=> cheesburger

# -------
# Un tableau avec un seul élément pour le corp de la réponse
[200, {}, ["Bonjour le monde !"]]

# -------
# Avec trois éléments, ça marche aussi
# Fichier config.ru
class Application
  def call(env)
    [200, {}, ["Comment", "tu", "vas ?"]]
  end
end

run Application.new
