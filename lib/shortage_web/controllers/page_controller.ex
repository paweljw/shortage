defmodule ShortageWeb.PageController do
  use ShortageWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
