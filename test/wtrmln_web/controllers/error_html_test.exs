defmodule WtrmlnWeb.ErrorHTMLTest do
  use WtrmlnWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(WtrmlnWeb.ErrorHTML, "404", "html", []) =~ "Oops, you found a juicy slice of nothing!"
  end

  test "renders 500.html" do
    assert render_to_string(WtrmlnWeb.ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
