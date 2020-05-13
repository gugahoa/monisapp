defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance

  def update(%{current_user: user} = assigns, socket) do
    socket = assign(socket, :accounts, Finance.list_accounts(user))
    assigns = Map.merge(socket.assigns, assigns)
    {:ok, %{socket | assigns: assigns}}
  end

  def handle_event("change-forms", %{"account" => search_term} = params, socket) do
    {:noreply, assign(socket, :accounts, Finance.search_accounts(search_term))}
  end
end
