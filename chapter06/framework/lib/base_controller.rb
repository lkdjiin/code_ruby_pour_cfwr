class BaseController

  private

  def render(filename)
    status, body = Renderer.new(File.join('views', filename)).render
    [status, {}, [body]]
  end
end
