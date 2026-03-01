defmodule ForthInterpreterElixirWeb.ErrorJSONTest do
  use ForthInterpreterElixirWeb.ConnCase, async: true

  test "renders 404" do
    assert ForthInterpreterElixirWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert ForthInterpreterElixirWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
