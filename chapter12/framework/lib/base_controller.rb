class BaseController
  include Error

  def initialize(params)
    @params = params
  end

  private

  attr_reader :params

  def render(filename)
    @binding = binding
    status, body = Renderer.new(File.join('views', filename), @binding).render
    [status, {}, [body]]
  end

  def partial(filename)
    Renderer.new(File.join('views', filename), binding).render_partial
  end

  def redirect_to(path)
    [303, {'Location' => path}, ['303 See Other']]
  end

  def content_for(name, value)
    @binding.local_variable_set(name, value)
  end
end
