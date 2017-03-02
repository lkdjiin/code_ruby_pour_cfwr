class GreetingsController < BaseController
  def hello
    render "hello.html"
  end

  def hola
    render "hola.html"
  end
end
