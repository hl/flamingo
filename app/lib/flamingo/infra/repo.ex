defmodule Flamingo.Infra.Repo do
  use Ecto.Repo,
    otp_app: :flamingo,
    adapter: Ecto.Adapters.SQLite3

  use Boundary
end
