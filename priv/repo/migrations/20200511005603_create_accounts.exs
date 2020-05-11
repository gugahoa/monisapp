defmodule MonisApp.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :amount, :decimal
      add :is_active, :boolean, default: false, null: false
      add :type, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:user_id])
  end
end
