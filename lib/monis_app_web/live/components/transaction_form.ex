defmodule MonisAppWeb.TransactionForm do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :amount, :decimal
    field :toggle, :boolean, default: true
    field :note, :string
    field :payee, :string

    field :account_id, :id
    field :account, :string
    field :category, :string
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :note, :payee, :account, :category, :toggle])
    |> validate_required([:amount, :payee, :account, :category])
  end

  def new() do
    %__MODULE__{}
    |> changeset(%{})
  end
end
