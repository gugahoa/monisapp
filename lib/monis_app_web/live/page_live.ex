defmodule MonisAppWeb.PageLive do
  use MonisAppWeb, :live_view

  alias MonisApp.Accounts

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign_new(:current_user, fn ->
        Accounts.get_user_by_session_token(token)
      end)
      |> assign(:open_modal, false)

    {:ok, socket}
  end

  def handle_event("open-modal", _, socket) do
    {:noreply, assign(socket, :open_modal, true)}
  end

  def handle_event("close-modal", _, socket) do
    {:noreply, assign(socket, :open_modal, false)}
  end
end
