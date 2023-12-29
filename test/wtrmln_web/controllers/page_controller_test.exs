defmodule WtrmlnWeb.PageControllerTest do
  use WtrmlnWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "<h1 class=\"text-2xl font-bold p-4\">WTRMLN CHAT</h1>" 
  end
end
