class BaseController

  private

  def render(filename)
    status, body = Renderer.new(File.join('views', filename), binding).render
    [status, {}, [body]]
  end
end
