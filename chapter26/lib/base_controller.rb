class BaseController
  include Error
  include ERB::Util
  include Logging

  def initialize(params, notice)
    @params = params
    @notice = notice
    @headers = {}
  end

  private

  attr_reader :params

  def render(filename)
    @binding = binding
    status, body = Renderer.new(File.join('views', filename), @binding).render
    [status, @headers, [body]]
  end

  def render_json(object, status: 200)
    @binding = binding
    body = APIRenderer.new(object, @binding).render
    [status, @headers.merge!({'Content-Type' => 'application/json'}), [body]]
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

  def headers(hash)
    @headers.merge!(hash)
  end
end
