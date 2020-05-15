defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance
  alias MonisAppWeb.TransactionForm

  def update(%{current_user: user} = assigns, socket) do
    changeset = TransactionForm.new()

    socket =
      socket
      |> assign(assigns)
      |> assign(:accounts, Finance.list_accounts(user))
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event(
        "change-forms",
        %{
          "_target" => ["transaction_form", "account"],
          "transaction_form" => %{"account" => search_term}
        },
        socket
      ) do
    socket =
      socket
      |> assign(:accounts, Finance.search_accounts(search_term))
      |> assign(
        :changeset,
        TransactionForm.changeset(socket.assigns[:changeset], %{
          account: search_term
        })
      )

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
