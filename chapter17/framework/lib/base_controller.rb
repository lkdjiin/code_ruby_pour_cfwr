class BaseController
  include Error
  include ERB::Util

  def initialize(params, notice)
    @params = params
    @notice = notice
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

  def notice?
    @notice.value
  end

  def notice(value = nil)
    if value
      @notice.value = value
    else
      @notice.value
    end
  end
end
