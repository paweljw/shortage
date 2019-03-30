defmodule Shortage.Redirects.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "links" do
    field :short, :string
    field :target, :string

    timestamps()

    field :visit_count, :integer, virtual: true
    has_many :visits, Shortage.Redirects.Visit
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:target, :short])
    |> validate_required([:target, :short])
  end
end
