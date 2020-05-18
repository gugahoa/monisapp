defmodule MonisApp.Factory do
  use ExMachina.Ecto, repo: MonisApp.Repo

  alias MonisApp.Accounts
  alias MonisApp.Accounts.User

  def user_factory() do
    %User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      confirmed_at: NaiveDateTime.utc_now()
    }
  end

  def set_user_password(user, password) do
    user
    |> Accounts.change_user_password(%{password: password, password_confirmation: password})
    |> Ecto.Changeset.apply_action!(:insert)
  end
end
