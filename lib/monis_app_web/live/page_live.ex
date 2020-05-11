defmodule MonisAppWeb.PageLive do
  use MonisAppWeb, :live_view

  def mount(_params, session, socket) do
    IO.puts "MonisAppWeb.PageLive: mount/3 #{inspect({session, socket})}"
    {:ok, socket}
  end
end
