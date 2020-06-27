defmodule MonisApp.Repo.Migrations.MakeCategoryNameUnique do
  use Ecto.Migration

  def change do
    create unique_index(:categories, [:user_id, :name])
  end
end
