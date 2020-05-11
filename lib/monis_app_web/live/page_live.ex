defmodule MonisAppWeb.PageLive do
  use MonisAppWeb, :live_view

  alias MonisApp.Accounts

  def mount(_params, %{"user_token" => token} = session, socket) do
    IO.puts("MonisAppWeb.PageLive: mount/3 #{inspect({session, socket})}")

    socket =
      assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(token) end)

    {:ok, socket}
  end
end
