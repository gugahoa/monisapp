defmodule MonisApp.AccountsTest do
  use MonisApp.DataCase

  alias MonisApp.Accounts

  describe "users" do
    alias MonisApp.Accounts.User

    @valid_attrs %{
      email: "some_valid@email.com",
      password: "valid password"
    }
    @update_attrs %{
      email: "some_updated@email.com",
      password: "updated valid password"
    }
    @invalid_attrs %{confirmed_at: nil, email: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.register_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "register_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.register_user(@valid_attrs)
      assert user.confirmed_at == nil
      assert user.email == "some_valid@email.com"
      assert Bcrypt.check_pass(user, "valid password")
    end

    test "register_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.register_user(@invalid_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user_registration/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_registration(user)
    end
  end
end
