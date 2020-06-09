defmodule MonisAppWeb.TransactionModalComponentTest do
  use MonisAppWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_login_user

  test "open-modal event opens add transaction modal component", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    refute html =~ "Add transaction"

    assert view
           |> element("#open-transaction-modal")
           |> render_click() =~ "Add transaction"
  end

  test "form correctly creates transaction", %{conn: conn, user: user} do
    account = insert(:account, user: user)
    category = insert(:category, user: user)

    {:ok, view, _html} = live(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert view
           |> element("#open-transaction-modal")
           |> render_click() =~ "Add transaction"

    assert {:ok, _view, html} =
             view
             |> element("form[phx-submit='create-transaction']")
             |> render_submit(%{
               transaction: %{
                 account_id: account.id,
                 category_id: category.id,
                 payee: "Example payee",
                 note: "Example note",
                 amount: 15
               }
             })
             |> follow_redirect(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert html =~ "successfully created"
    refute html =~ "Add transaction"

    assert MonisApp.Finance.list_transactions() != []
  end
end
