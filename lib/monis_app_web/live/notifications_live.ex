defmodule MonisAppWeb.NotificationsLive do
  use MonisAppWeb, :live_view

  alias MonisApp.Accounts

  def mount(_params, %{"user_token" => token}, socket) do
    socket =
      socket
      |> assign(:notifications, [])
      |> assign_new(:current_user, fn ->
        Accounts.get_user_by_session_token(token)
      end)

    user = socket.assigns[:current_user]
    Phoenix.PubSub.subscribe(MonisApp.PubSub, "user_notifications:#{user.id}")

    {:ok, socket}
  end

  def success(user, title, message \\ nil) do
    put_notification(user, %{type: :success, title: title, message: message})
  end

  def error(user, title, message \\ nil) do
    put_notification(user, %{type: :error, title: title, message: message})
  end

  defp put_notification(user, notification) do
    ref = make_ref()
    notification = Map.put(notification, :ref, ref)

    Phoenix.PubSub.broadcast!(
      MonisApp.PubSub,
      "user_notifications:#{user.id}",
      {:add, notification}
    )
  end

  def handle_info({:add, notification}, socket) do
    notification =
      notification
      |> Map.put_new(:ref, make_ref())
      |> Map.put(:clear, false)

    Process.send_after(self(), {:fade, notification.ref}, 4_000)
    Process.send_after(self(), {:clear, notification.ref}, 5_000)

    socket =
      socket
      |> assign_new(:notifications, fn -> [] end)
      |> update(:notifications, fn
        [] -> [notification]
        notifications -> [notification | notifications]
      end)

    {:noreply, socket}
  end

  def handle_info({:fade, ref}, socket) do
    socket =
      socket
      |> assign_new(:notifications, fn -> [] end)
      |> update(:notifications, &fade_notification(ref, &1))

    {:noreply, socket}
  end

  def handle_info({:clear, ref}, socket) do
    socket =
      socket
      |> assign_new(:notifications, fn -> [] end)
      |> update(:notifications, &clear_notification(ref, &1))

    {:noreply, socket}
  end

  defp fade_notification(_ref, []), do: []

  defp fade_notification(ref, notifications) do
    Enum.map(notifications, fn
      %{ref: ^ref} = notification -> Map.put(notification, :clear, true)
      notification -> notification
    end)
  end

  defp clear_notification(_ref, []), do: []

  defp clear_notification(ref, notifications) do
    Enum.reject(notifications, fn
      %{ref: ^ref} -> true
      _ -> false
    end)
  end
end
