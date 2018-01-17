class TestController < BaseController
  def show
    render_json({ message: "Bloommmmm"})
  end
end
