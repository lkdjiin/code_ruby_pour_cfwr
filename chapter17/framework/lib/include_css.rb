class IncludeCSS
  def self.call
    files = YAML.load_file("assets/css/css.yml")
    files.map do |file|
      "<link rel='stylesheet' type='text/css' href='/css/#{file}'>\n"
    end.join
  end
end
