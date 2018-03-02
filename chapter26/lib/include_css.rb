class IncludeCSS
  def self.call
    new.call
  end

  def initialize
    @names = {
      full: 'assets/css/full.css',
      yaml: 'assets/css/css.yml',
    }
  end

  def call
    production? ? single_serve : multiple_serve
  end

  private

  attr_reader :names

  def production?
    ENV["RACK_ENV"] == "production"
  end

  def single_serve
    full_build
    "<link rel='stylesheet' type='text/css' href='/css/full.css'>\n"
  end

  public def full_build
    return if full_css_present?

    File.write(names[:full], CSSminify.compress(full_content))
  end

  def full_css_present?
    File.exists?(names[:full])
  end

  def full_content
    css_files.map { |file| File.read("assets/css/#{file}") }.join
  end

  def css_files
    YAML.load_file(names[:yaml])
  end

  def multiple_serve
    css_files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end
end
