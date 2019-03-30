defmodule Shortage.Repo do
  use Ecto.Repo,
    otp_app: :shortage,
    adapter: Ecto.Adapters.Postgres
end
