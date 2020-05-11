defmodule MonisAppWeb.UserSessionController do
  use MonisAppWeb, :controller

  alias MonisApp.Accounts
  alias MonisAppWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      UserAuth.login_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid email and password combination")
    end
  end
end
