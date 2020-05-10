defmodule MonisAppWeb.UserRegistrationController do
  use MonisAppWeb, :controller

  alias MonisApp.Accounts.User
  alias MonisApp.Accounts
  alias MonisAppWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})

    conn
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.login_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
