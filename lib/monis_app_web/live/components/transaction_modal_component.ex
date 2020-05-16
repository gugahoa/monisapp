defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance
  alias MonisAppWeb.TransactionForm

  # TODO: Delete TransactionForm, use MonisApp.Finance.Transaction
  # TODO: Delete :account_name assign, use the virtual field :account_name in Transaction
  # TODO: Somehow make an autocomplete that doesn't look so bad, and retains at least a little bit of a11y
  def update(%{current_user: user} = assigns, socket) do
    changeset = TransactionForm.new()

    socket =
      socket
      |> assign(assigns)
      |> assign(:account_name, "")
      |> assign(:accounts, [])
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event(
        "change-forms",
        %{
          "_target" => ["transaction_form", "account_name"],
          "transaction_form" => %{"account_name" => search_term}
        },
        socket
      ) do
    socket =
      socket
      |> assign(:accounts, Finance.search_accounts(search_term))
      |> assign(:account_name, search_term)

    {:noreply, socket}
  end

  def handle_event(
        "change-forms",
        %{"_target" => ["transaction_form" | _], "transaction_form" => transaction},
        socket
      ) do
    {:noreply,
     assign(
       socket,
       :changeset,
       TransactionForm.changeset(socket.assigns[:changeset], transaction)
     )}
  end

  def handle_event("create-transaction", _, socket) do
    {:noreply, socket}
  end
end
