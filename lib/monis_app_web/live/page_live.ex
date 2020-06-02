defmodule MonisAppWeb.PageLive do
  use MonisAppWeb, :live_view

  alias MonisApp.Accounts

  def mount(_params, %{"user_token" => token} = session, socket) do
    IO.puts("MonisAppWeb.PageLive: mount/3 #{inspect({session, socket.assigns})}")

    socket =
      socket
      |> assign_new(:current_user, fn ->
        Accounts.get_user_by_session_token(token)
      end)
      |> assign(:open_modal, true)

    {:ok, socket}
  end

  def handle_event("open-modal", _, socket) do
    {:noreply, assign(socket, :open_modal, true)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, :open_modal, false)}
  end
end
