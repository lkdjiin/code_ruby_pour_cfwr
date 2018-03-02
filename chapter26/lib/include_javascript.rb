class IncludeJavascript
  def self.call
    files = YAML.load_file("assets/js/js.yml")
    files.map do |file|
      "<script src='/js/#{file}'></script>"
    end.join
  end
end
