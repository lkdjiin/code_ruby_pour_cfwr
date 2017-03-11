class BaseController

  def initialize(params)
    @params = params
  end

  private

  attr_reader :params

  def render(filename)
    status, body = Renderer.new(File.join('views', filename), binding).render
    [status, {}, [body]]
  end

  def redirect_to(path)
    [303, {'Location' => path}, ['303 See Other']]
  end
end
