E404 = Class.new(StandardError)

module Error
  def error_404
    [404, {"Content-Type" => "text/html"}, [File.read("public/404.html")]]
  end

  def api_error_404
    [
      404,
      {"Content-Type" => "application/json"},
      [{error: "Not found"}.to_json]
    ]
  end

  def error_500
    [500, {"Content-Type" => "text/html"}, [File.read("public/500.html")]]
  end

  def api_error_500(msg)
    [
      500,
      {"Content-Type" => "application/json"},
      [{error: "Server Error. #{msg}"}.to_json]
    ]
  end
end
