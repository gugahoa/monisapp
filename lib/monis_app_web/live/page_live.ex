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

  defp list_balances(user), do: MonisApp.Finance.list_balances(user)

  defp balance_color(balance) do
    cond do
      Decimal.positive?(balance) ->
        "text-green-700"

      Decimal.negative?(balance) ->
        "text-red-700"

      true ->
        "text-black"
    end
  end

  defp last_transaction_text(nil), do: "No transaction recorded yet"

  defp last_transaction_text(date) do
    "Last transaction was #{Timex.format!(date, "{relative}", :relative)}"
  end
end
