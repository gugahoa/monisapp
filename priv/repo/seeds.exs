# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MonisApp.Repo.insert!(%MonisApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, user} =
  MonisApp.Accounts.register_user(%{
    email: "gustavo@monis.app",
    password: "some password",
    password_confirmation: "some password"
  })

{:ok, _} = MonisApp.Finance.create_default_categories(user)
{:ok, _} = MonisApp.Finance.create_account(user, %{name: "NuConta", type: "checking"})
