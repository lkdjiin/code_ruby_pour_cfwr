module Partial
  def partial(filename)
    b = @binding || binding
    Renderer.new(File.join('views', filename), b).render_partial
  end
end
