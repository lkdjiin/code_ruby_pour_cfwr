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

          def new
          end

          def create
          end

          def edit
          end

          def update
          end

          def delete
          end
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
