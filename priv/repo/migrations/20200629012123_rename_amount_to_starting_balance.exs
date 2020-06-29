defmodule MonisApp.Repo.Migrations.RenameAmountToStartingBalance do
  use Ecto.Migration

  def change do
    rename table(:accounts), :amount, to: :starting_balance
  end
end
