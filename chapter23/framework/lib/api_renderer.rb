class APIRenderer

  def initialize(filename_or_object, binding)
    @object = filename_or_object
    @binding = binding
  end

  def render
    if view?
      ERB.new(template).result(@binding)
    else
      @object.to_json
    end
  end

  def template
    File.read(view_file)
  end

  def view?
    @object.is_a?(String) && File.exists?(view_file)
  end

  def view_file
    File.join('views', @object)
  end

end
