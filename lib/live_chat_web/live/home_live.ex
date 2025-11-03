defmodule LiveChatWeb.HomeLive do
  use LiveChatWeb, :live_view
  alias Phoenix.PubSub

  def mount(%{"chat_id" => chat_id}, _session, socket) do
    PubSub.subscribe(LiveChat.PubSub, chat_id)
    {:ok, assign(socket, chat_id: chat_id, form: to_form(%{}), messages: [])}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col">
      <%= for {pid, message} <- @messages do %>
        <div class={"border p-2 bg-gray-300 #{if pid == self(), do: "self-start text-start", else: "self-end text-end"}"}>
          <p>{inspect(pid)}:</p>
          <p>{message}</p>
        </div>
      <% end %>
    </div>
    <.form for={@form} id="chat-form" phx-submit="send_message">
      <.input type="text" field={@form[:message]} />
      <button>Save</button>
    </.form>
    """
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    PubSub.broadcast(LiveChat.PubSub, socket.assigns.chat_id, {self(), message})
    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    {:noreply, update(socket, :messages, fn messages -> IO.inspect(messages ++ [msg]) end)}
  end
end
