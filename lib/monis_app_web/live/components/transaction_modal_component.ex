defmodule MonisAppWeb.TransactionModalComponent do
  use Phoenix.LiveComponent

  alias MonisApp.Finance
  alias MonisApp.Finance.Transaction

  def mount(socket) do
    IO.puts "TransactionModalComponent: mount/1 #{inspect(socket.assigns)}"
    {:ok, assign(
      socket,
      changeset: Finance.change_transaction(%Transaction{})
    )}
  end
end
