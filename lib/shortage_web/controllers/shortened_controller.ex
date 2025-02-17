defmodule ShortageWeb.ShortenedController do
  use ShortageWeb, :controller
  alias Shortage.Redirects

  def show(conn, %{"shortened" => shortened}) do
    link = Redirects.get_link_by_short!(shortened)
    Redirects.increment_visit(link)
    redirect(conn, external: link.target)
  end
end
