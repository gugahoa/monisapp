defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance

  def update(%{current_user: user} = assigns, socket) do
    socket = assign(socket, :accounts, Finance.list_accounts(user))
    assigns = Map.merge(socket.assigns, assigns)
    {:ok, %{socket | assigns: assigns}}
  end

  def handle_event(
        "change-forms",
        %{"_target" => targets, "account" => search_term} = params,
        socket
      ) do
    socket =
      if "account" in targets do
        assign(socket, :accounts, Finance.search_accounts(search_term))
      else
        socket
      end

    IO.inspect(params)
    {:noreply, socket}
  end
end
