defmodule ShortageWeb.LinkController do
  use ShortageWeb, :controller

  alias Shortage.Redirects
  alias Shortage.Redirects.Link

  def index(conn, _params) do
    links = Redirects.list_links()
    render(conn, "index.html", links: links)
  end

  def new(conn, _params) do
    changeset = Redirects.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params}) do
    strong_short = :crypto.strong_rand_bytes(5) |> Base.url_encode64() |> binary_part(0, 5)
    augmented_params = Map.merge(link_params, %{"short" => strong_short})

    case Redirects.create_link(augmented_params) do
      {:ok, link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: Routes.link_path(conn, :show, link))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    link = Redirects.get_link!(id)
    render(conn, "show.html", link: link)
  end

  def delete(conn, %{"id" => id}) do
    link = Redirects.get_link!(id)
    {:ok, _link} = Redirects.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: Routes.link_path(conn, :index))
  end
end
