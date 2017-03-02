class HelloController
  def index
    status, body = Renderer.new("hello.html").render
    [status, {}, [body]]
  end
end
