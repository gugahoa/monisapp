defmodule MonisApp.Repo.Migrations.MakeAcconutNameUnique do
  use Ecto.Migration

  def change do
    create unique_index(:accounts, [:name])
  end
end
