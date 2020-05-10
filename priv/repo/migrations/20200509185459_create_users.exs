defmodule MonisApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :string
      add :hashed_password, :string
      add :confirmed_at, :naive_datetime

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
