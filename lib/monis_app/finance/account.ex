defmodule MonisApp.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :amount, :decimal, default: 0
    field :is_active, :boolean, default: true
    field :type, :string, null: false
    field :name, :string, null: false

    belongs_to :user, MonisApp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :is_active, :type, :name])
    |> validate_required([:amount, :is_active, :type, :name])
    |> unique_constraint(:name)
  end
end
