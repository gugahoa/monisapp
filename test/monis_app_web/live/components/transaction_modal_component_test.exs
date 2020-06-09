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
end
