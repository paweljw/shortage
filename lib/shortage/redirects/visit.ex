defmodule Shortage.Redirects.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "visits" do
    field :count, :integer
    field :visited_on, :date
    field :link_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:visited_on, :count])
    |> validate_required([:visited_on, :count])
  end
end
