defmodule MonisApp.Repo do
  use Ecto.Repo,
    otp_app: :monisapp,
    adapter: Ecto.Adapters.Postgres
end
