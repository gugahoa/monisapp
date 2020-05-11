defmodule MonisApp.Repo do
  use Ecto.Repo,
    otp_app: :monis_app,
    adapter: Ecto.Adapters.Postgres
end
