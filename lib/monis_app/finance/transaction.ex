defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :note, :string
    field :payee, :string

    belongs_to :account, MonisApp.Finance.Account

    field :category_name, :string, virtual: true
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:payee, :amount, :note, :account_id, :category_id, :category_name])
    |> validate_required([:payee, :amount, :category_id, :account_id])
  end
end
