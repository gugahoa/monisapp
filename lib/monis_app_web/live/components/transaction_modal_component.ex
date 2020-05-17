defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance
  alias MonisApp.Finance.Transaction

  # TODO: Somehow make an autocomplete that doesn't look so bad, and retains at least a little bit of a11y
  def update(%{current_user: user} = assigns, socket) do
    changeset = Finance.change_transaction(%Transaction{})

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
          "_target" => ["transaction", "account_name"],
          "transaction" => %{"account_name" => search_term}
        },
        socket
      ) do
    socket =
      socket
      |> assign(:accounts, Finance.search_accounts(search_term))

    {:noreply, socket}
  end

  def handle_event("change-forms", %{"_target" => target, "transaction" => transaction}, socket) do
    IO.puts("#{inspect(target)}")

    socket =
      socket
      |> assign(:changeset, Finance.change_transaction(%Transaction{}, transaction))

    {:noreply, socket}
  end

  def handle_event("create-transaction", _, socket) do
    {:noreply, socket}
  end
end
