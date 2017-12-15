class Renderer

  # module Content
  #   def content_for(label, content)
  #     local_variable_set(label, content)
  #   end
  # end

  def initialize(filename, binding)
    @filename = filename
    @binding = binding
  end

  def render
    if File.exists?(@filename)
      [200, result]
    else
      no_template
    end
  end

  def render_partial
    if File.exists?(@filename)
      ERB.new(template).result(@binding)
    else
      no_template
    end
  end

  private

  def result
    # @binding.extend Content
    content = ERB.new(template).result(@binding)
    insert_in_main_template { content }
  end

  def template
    File.read(@filename)
  end

  def insert_in_main_template
    ERB.new(main_template).result(binding)
  end

  def main_template
    File.read('views/layouts/application.html.erb')
  end

  def no_template
    puts "Erreur 500 Template inconnu: #{@filename}"
    fail
  end

  def include_css
    IncludeCSS.call
  end

  def include_javascript
    IncludeJavascript.call
  end

  def include_partial(filename)
    Renderer.new(File.join('views', filename), @binding).render_partial
  end

  def include_content(label)
    @binding.local_variable_get(label)
  rescue
    nil
  end
end
