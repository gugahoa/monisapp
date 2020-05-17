defmodule MonisApp.Finance.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :decimal
    field :note, :string
    field :payee, :string

    field :account_name, :string, virtual: true
    belongs_to :account, MonisApp.Finance.Account

    field :category_name, :string, virtual: true
    belongs_to :category, MonisApp.Finance.Category

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:payee, :amount, :note, :account_name, :category_name])
    |> validate_required([:payee, :amount, :note])
  end
end
