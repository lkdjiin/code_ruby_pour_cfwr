class Renderer
  def initialize(filename)
    @filename = filename
  end

  def render
    if File.exists?(@filename)
      [200, File.read(@filename)]
    else
      [500, "<h1>500</h1><p>No such template: #{@filename}</p>"]
    end
  end
end

