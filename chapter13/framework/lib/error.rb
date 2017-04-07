E404 = Class.new(StandardError)

module Error
  def error_404
    [404, {"Content-Type" => "text/html"}, [File.read("public/404.html")]]
  end

  def error_500
    [500, {"Content-Type" => "text/html"}, [File.read("public/500.html")]]
  end
end
