defmodule MonisApp.Repo.Migrations.AddDateToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :date, :date, null: false
    end
  end
end
