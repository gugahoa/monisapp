defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance

  def update(%{current_user: user} = assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(accounts: Finance.list_accounts(user))
      
    {:ok, socket}
  end

  def handle_event(
        "change-forms",
        %{"_target" => ["account"], "account" => search_term},
        socket
      ) do
    {:noreply, assign(socket, :accounts, Finance.search_accounts(search_term))}
  end

  def handle_event("change-forms", _, socket) do
    {:noreply, socket}
  end
end
