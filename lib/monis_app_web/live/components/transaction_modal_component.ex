defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  alias MonisApp.Finance
  alias MonisApp.Finance.Transaction

  def update(%{current_user: user} = assigns, socket) do
    changeset = Finance.change_transaction(%Transaction{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:categories, [%{id: -1, name: "Category"} | Finance.list_categories(user)])
      |> assign(:accounts, [%{id: -1, name: "Account"} | Finance.list_accounts(user)])
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event("change-forms", %{"transaction" => transaction}, socket) do
    socket =
      socket
      |> assign(:changeset, Finance.change_transaction(%Transaction{}, transaction))

    {:noreply, socket}
  end

  def handle_event("category-selected", %{"category_id" => id}, socket) do
    category = Finance.get_category(socket.assigns[:current_user], id)

    if category != nil do
      data =
        socket.assigns[:changeset].changes
        |> Map.put(:category_id, id)

      {:noreply, assign(socket, :changeset, Finance.change_transaction(%Transaction{}, data))}
    else
      data =
        socket.assigns[:changeset].changes
        |> Map.delete(:category_id)

      {:noreply, assign(socket, :changeset, Finance.change_transaction(%Transaction{}, data))}
    end
  end

  def handle_event("account-selected", %{"account_id" => account_id}, socket) do
    account = Finance.get_account(socket.assigns[:current_user], account_id)

    if account != nil do
      data =
        socket.assigns[:changeset].changes
        |> Map.put(:account_id, account_id)

      {:noreply, assign(socket, :changeset, Finance.change_transaction(%Transaction{}, data))}
    else
      data =
        socket.assigns[:changeset].changes
        |> Map.delete(:account_id)

      {:noreply, assign(socket, :changeset, Finance.change_transaction(%Transaction{}, data))}
    end
  end

  def handle_event("create-transaction", %{"transaction" => attrs}, socket) do
    changeset = Transaction.form_changeset(socket.assigns[:changeset], attrs)
    {:noreply, assign(socket, :changeset, changeset)}
  end
end
