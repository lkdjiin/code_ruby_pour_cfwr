# --- Un générateur bidon
# Fichier lib/generators/controller.rb
module Generators
  class Controller
    def self.generate(name:)
      puts "Hello, #{name}"
    end
  end
end


# --- Une tâche Rake pour créer un contrôleur
# Fichier Rakefile
namespace :create do
  desc "Create a controller"
  task :controller, [:name] do |t, args|
    require_relative "lib/generators/controller"
    puts "Creating controller…"
    Generators::Controller.generate(name: args[:name])
    puts "Done."
  end
end


# --- Majuscule
"articles".capitalize
#=> "Articles"


# -- HEREDOC I
string = <<DOCUMENT
    foo
       bar
DOCUMENT
puts string
#=>    foo
#=>       bar


# --- HEREDOC II
def code
  <<CONTENT
    class Articles
      def index
      end
    end
CONTENT
end


# --- Le résultat laisse à désirer
puts code
#=>     class Articles
#=>       def index
#=>       end
#=>     end


# --- HEREDOC III
def code
  <<CONTENT
class Articles
  def index
  end
end
CONTENT
end


# --- HEREDOC IV, enfin…
def code
  <<~CONTENT
    class Articles
      def index
      end
    end
  CONTENT
end

puts code
#=> class Articles
#=>   def index
#=>   end
#=> end


# --- Une version préliminaire
# Fichier lib/generators/controller.rb
module Generators
  class Controller
    def self.generate(name:)
      puts new(name).code
    end

    def initialize(name)
      @name = name.capitalize
    end

    def code
      <<~CODE
        class #{@name} < BaseController
          def index
          end

          def show
          end

          def delete
          end

          # ...
        end
      CODE
    end
  end
end


# --- Un peu de travail sur les chaînes
module Generators
  class Controller
    def initialize(name)
      @filename = "#{name}_controller.rb"
      @classname = name.split('_').map(&:capitalize).join
    end
  end
end


# --- Un générateur qui fait son job
# Fichier lib/generators/controller.rb
module Generators
  class Controller
    def self.generate(name:)
      new(name).generate
    end

    def initialize(name)
      @filename = "#{name}_controller.rb"
      @classname = name.split('_').map(&:capitalize).join
    end

    def generate
      File.write("#{path}/#{filename}", code)
    end

    private

    attr_reader :filename

    def path
      "controllers"
    end

    def code
      <<~CODE
        class #{@classname} < BaseController
          def index
          end

          def show
          end

          def delete
          end

          # ...
        end
      CODE
    end
  end
end


# --- Un contrôleur avec des actions personnalisées
class ClientsController < BaseController
  def subscribe
  end

  def unsubscribe
  end
end


# --- Rake et les arguments
# Fichier Rakefile
namespace :create do
  desc "Create a controller"
  task :controller do |t, args|
    p args.extras
  end
end


# --- La nouvelle tâche Rake
# Fichier Rakefile
namespace :create do
  desc "Create a controller"
  task :controller do |t, args|
    require_relative "lib/generators/controller"
    puts "Creating controller…"
    Generators::Controller.generate(args.extras)
    puts "Done."
  end
end


# --- Le générateur final
# Fichier lib/generators/controller.rb
module Generators
  class Controller
    def self.generate(args)
      new(args).generate
    end

    def initialize(args)
      name = args.shift
      @actions = args
      @filename = "#{name}_controller.rb"
      @classname = name.split('_').each(&:capitalize!).join
    end

    def generate
      File.write(file_location, code)
    end

    private

    attr_reader :filename, :actions, :classname

    def file_location
      "controllers/#{filename}"
    end

    def code
      actions.empty? ? standard : custom
    end

    def standard
      <<~STANDARD
        class #{classname} < BaseController
          def index
          end

          def show
          end

          def delete
          end

          # ...
        end
      STANDARD
    end

    def custom
      "class #{classname} < BaseController\n" +
        actions.map { |action| "  def #{action}\n  end\n" }.join("\n") +
        "end\n"
    end
  end
end
