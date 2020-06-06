defmodule MonisAppWeb.UserRegistrationControllerTest do
  use MonisAppWeb.ConnCase, async: true

  import MonisApp.Factory

  describe "GET /users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.user_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "Cadastre-se</h1>"
      assert response =~ "login</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> login_user(insert(:user)) |> get(Routes.user_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => email, "password" => valid_user_password()}
        })

      user_token = get_session(conn, :user_token)
      assert user_token
      assert redirected_to(conn) =~ "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Logout</a>"

      user = MonisApp.Accounts.get_user_by_session_token(user_token)

      assert length(MonisApp.Finance.list_categories(user)) ==
               length(MonisApp.Finance.default_categories())
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.user_registration_path(conn, :create), %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Cadastre-se</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
