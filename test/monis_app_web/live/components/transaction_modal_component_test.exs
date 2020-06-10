defmodule MonisAppWeb.TransactionModalComponentTest do
  use MonisAppWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_login_user

  test "open-modal event opens add transaction modal component", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert html =~ "open_transaction_modal: false"

    assert view
           |> element("#open-transaction-modal")
           |> render_click() =~ "Add transaction"

    assert render(view) =~ "open_transaction_modal: true"
  end

  test "form correctly creates transaction", %{conn: conn, user: user} do
    account = insert(:account, user: user)
    category = insert(:category, user: user)

    {:ok, view, _html} = live(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert view
           |> element("#open-transaction-modal")
           |> render_click() =~ "Add transaction"

    assert {:ok, view, html} =
             view
             |> form("form[phx-submit='create-transaction']", %{
               transaction: %{
                 account_id: account.id,
                 category_id: category.id,
                 payee: "Payee",
                 note: "Example note",
                 amount: 15
               }
             })
             |> render_submit()
             |> follow_redirect(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert html =~ "successfully created"

    assert render(view) =~ "open_transaction_modal: false"

    assert MonisApp.Finance.list_transactions() != []
  end
end
