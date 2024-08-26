defmodule WtrmlnWeb.PageController do
  use WtrmlnWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
