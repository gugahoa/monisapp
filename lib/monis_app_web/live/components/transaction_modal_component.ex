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
        %{"_target" => targets, "account" => search_term} = params,
        socket
      ) do
    socket =
      if "account" in targets do
        assign(socket, :accounts, Finance.search_accounts(search_term))
      else
        socket
      end

    {:noreply, socket}
  end
end
