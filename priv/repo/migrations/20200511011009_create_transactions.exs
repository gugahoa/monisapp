defmodule MonisApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :payee, :string
      add :amount, :decimal
      add :note, :string
      add :category_id, references(:categories, on_delete: :nothing)
      add :account_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:category_id])
    create index(:transactions, [:account_id])
  end
end
