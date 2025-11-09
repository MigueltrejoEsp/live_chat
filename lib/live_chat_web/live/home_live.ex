defmodule LiveChatWeb.HomeLive do
  use LiveChatWeb, :live_view
  alias Phoenix.PubSub

  def mount(%{"chat_id" => chat_id}, _session, socket) do
    PubSub.subscribe(LiveChat.PubSub, chat_id)
    {:ok, assign(socket, chat_id: chat_id, form: to_form(%{}), messages: [], username: nil)}
  end

  def render(assigns) do
    ~H"""
    <%= if !@username do %>
      <div>
        <div>
          <h2>Welcome to Live Chat!</h2>
          <p>Tell us your username.</p>
          <.form for={@form} id="user-name" phx-submit="set_username">
            <.input type="text" field={@form[:username]} />
            <button>Start</button>
          </.form>
        </div>
      </div>
    <% end %>
    <%= if @username do %>
      <div class="flex flex-col">
        <%= for {username, message} <- @messages do %>
          <div class={"border p-2 bg-gray-300 #{if username == @username, do: "self-end text-end", else: "self-start text-start"}"}>
            <p>{inspect(username)}:</p>
            <p>{message}</p>
          </div>
        <% end %>
      </div>
      <.form for={@form} id="chat-form" phx-submit="send_message">
        <.input type="text" field={@form[:message]} />
        <button>Save</button>
      </.form>
    <% end %>
    """
  end

  def handle_event("set_username", %{"username" => username}, socket) do
    {:noreply, assign(socket, username: username, form: to_form(%{}))}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    PubSub.broadcast(LiveChat.PubSub, socket.assigns.chat_id, {socket.assigns.username, message})
    {:noreply, socket}
  end

  def handle_info(msg, socket) do
    {:noreply, update(socket, :messages, fn messages -> IO.inspect(messages ++ [msg]) end)}
  end
end
