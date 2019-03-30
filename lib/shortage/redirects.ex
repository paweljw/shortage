defmodule Shortage.Redirects do
  @moduledoc """
  The Redirects context.
  """

  import Ecto.Query, warn: false
  alias Shortage.Repo

  alias Shortage.Redirects.Link
  alias Shortage.Redirects.Visit

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  def list_links_with_visits do
    Repo.all(
      from link in Link,
        left_join: visit in assoc(link, :visits),
        group_by: link.id,
        select_merge: %{visit_count: sum(fragment("coalesce(?,0)", visit.count))}
    )
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id) do
    Repo.one!(
      from link in Link,
        left_join: visit in assoc(link, :visits),
        group_by: link.id,
        where: link.id == ^id,
        select_merge: %{visit_count: sum(fragment("coalesce(?,0)", visit.count))}
    )
  end

  def get_link_visits(id) do
    Repo.all(from v in Visit, order_by: :visited_on, where: v.link_id == ^id)
  end

  def get_link_by_short!(short), do: Repo.get_by!(Link, short: short)

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{source: %Link{}}

  """
  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end

  alias Shortage.Redirects.Visit

  @doc """
  Returns the list of visits.

  ## Examples

      iex> list_visits()
      [%Visit{}, ...]

  """
  def list_visits do
    Repo.all(Visit)
  end

  @doc """
  Gets a single visit.

  Raises `Ecto.NoResultsError` if the Visit does not exist.

  ## Examples

      iex> get_visit!(123)
      %Visit{}

      iex> get_visit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_visit!(id), do: Repo.get!(Visit, id)

  @doc """
  Upserts the visit count for a link.

  """
  def increment_visit(link) do
    Repo.insert(%Visit{link_id: link.id, visited_on: Date.utc_today(), count: 1},
      conflict_target: [:link_id, :visited_on],
      on_conflict: [inc: [count: 1]]
    )
  end

  def visits_count(link) do
    Repo.aggregate(from(p in Visit, where: p.link_id == ^link.id), :sum, :count)
  end
end
