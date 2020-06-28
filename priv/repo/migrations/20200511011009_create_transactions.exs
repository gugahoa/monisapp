defmodule MonisApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :payee, :string, null: false
      add :amount, :decimal, null: false
      add :note, :string, null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false
      add :account_id, references(:accounts, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:transactions, [:category_id])
    create index(:transactions, [:account_id])
  end
end
