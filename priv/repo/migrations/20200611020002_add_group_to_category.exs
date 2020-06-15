defmodule MonisApp.Repo.Migrations.AddGroupToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :group, :string, null: false
    end
  end
end
