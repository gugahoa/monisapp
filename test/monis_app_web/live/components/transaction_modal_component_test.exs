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

  test "form correctly creates transaction with positive amount when toggle is checked", %{
    conn: conn,
    user: user
  } do
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
                 toggle: true,
                 amount: 15,
                 date: "2020-06-20"
               }
             })
             |> render_submit()
             |> follow_redirect(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert html =~ "successfully created"
    refute html =~ "Add transaction"

    assert [%{amount: amount}] = MonisApp.Finance.list_transactions()
    assert Decimal.positive?(amount)
  end

  test "form correctly creates transaction with negative amount when toggle is not checked", %{
    conn: conn,
    user: user
  } do
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
                 toggle: false,
                 amount: 15,
                 date: "2020-06-20"
               }
             })
             |> render_submit()
             |> follow_redirect(conn, Routes.live_path(conn, MonisAppWeb.PageLive))

    assert html =~ "successfully created"
    refute html =~ "Add transaction"

    assert [%{amount: amount}] = MonisApp.Finance.list_transactions()
    assert Decimal.negative?(amount)
  end
end
