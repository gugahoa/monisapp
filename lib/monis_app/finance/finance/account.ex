defmodule MonisApp.Finance.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :amount, :decimal
    field :is_active, :boolean, default: true
    field :type, :string
    belongs_to :user, MonisApp.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :is_active, :type])
    |> validate_required([:amount, :is_active, :type])
  end
end
