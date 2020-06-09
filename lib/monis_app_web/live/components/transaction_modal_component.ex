defmodule MonisAppWeb.TransactionModalComponent do
  use MonisAppWeb, :live_component

  alias MonisApp.Finance
  alias MonisApp.Finance.Transaction

  def update(%{current_user: user} = assigns, socket) do
    changeset = Finance.change_transaction(user, %Transaction{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:categories, Finance.list_categories(user))
      |> assign(:accounts, Finance.list_accounts(user))
      |> assign(:payees, Finance.list_payees(user))
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event("change-forms", %{"transaction" => transaction}, socket) do
    user = socket.assigns[:current_user]

    socket =
      socket
      |> assign(:changeset, Finance.change_transaction(user, %Transaction{}, transaction))

    {:noreply, socket}
  end

  def handle_event("category-selected", %{"category_id" => id}, socket) do
    user = socket.assigns[:current_user]
    category = Finance.get_category(user, id)

    data =
      if category != nil do
        socket.assigns[:changeset].changes
        |> Map.put(:category_id, id)
      else
        socket.assigns[:changeset].changes
        |> Map.delete(:category_id)
      end

    {:noreply, assign(socket, :changeset, Finance.change_transaction(user, %Transaction{}, data))}
  end

  def handle_event("payee-selected", %{"payee" => payee}, socket) do
    user = socket.assigns[:current_user]

    data =
      socket.assigns[:changeset].changes
      |> Map.put(:payee, payee)

    {:noreply, assign(socket, :changeset, Finance.change_transaction(user, %Transaction{}, data))}
  end

  def handle_event("account-selected", %{"account_id" => account_id}, socket) do
    user = socket.assigns[:current_user]
    account = Finance.get_account(user, account_id)

    data =
      if account != nil do
        socket.assigns[:changeset].changes
        |> Map.put(:account_id, account_id)
      else
        socket.assigns[:changeset].changes
        |> Map.delete(:account_id)
      end

    {:noreply, assign(socket, :changeset, Finance.change_transaction(user, %Transaction{}, data))}
  end

  def handle_event("create-transaction", %{"transaction" => attrs}, socket) do
    user = socket.assigns[:current_user]

    case Finance.create_transaction(user, attrs) do
      {:ok, _transaction} ->
        changeset = Finance.change_transaction(user, %Transaction{}, %{})

        socket =
          socket
          |> put_flash(:info, "Transaction successfully created!")
          |> assign(:changeset, changeset)

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
