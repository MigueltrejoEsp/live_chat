defmodule LiveChatWeb.ChatLive do
  use LiveChatWeb, :live_view
  alias Phoenix.PubSub

  def mount(%{"chat_id" => chat_id}, _session, socket) do
    PubSub.subscribe(LiveChat.PubSub, chat_id)
    {:ok, assign(socket, chat_id: chat_id, messages: [], form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <div class="h-full max-h-screen w-full overflow-y-scroll flex flex-col">
      <div class="flex-1 flex flex-col justify-end mx-2 sm:mx-6">
        <div
          :for={{pid, message} <- @messages}
          class={"chat #{if pid == self(), do: "chat-end", else: "chat-start"}"}
        >
          <div class={"chat-bubble #{if pid == self(), do: "chat-bubble-success", else: "chat-bubble-info"}"}>
            <p :if={pid != self()}>{inspect(pid)}:</p>
            <p>{message}</p>
          </div>
        </div>
      </div>
      <.simple_form
        id="chat_form"
        for={@form}
        phx-submit="send_message"
        phx-change="sync_form"
        class="w-80% flex-none flex flex-row items-center p-4"
        autocomplete="off"
      >
        <.chat_input
          field={@form[:message]}
          type="text"
          class={"flex-1 #{if empty?(@form[:message].value), do: "rounded-full", else: "rounded-l-full"}"}
        />
        <.button
          :if={not empty?(@form[:message].value)}
          type="submit"
          class="flex-none rounded-r-full no-animation"
          color="primary"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            class="size-6"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M6 12 3.269 3.125A59.769 59.769 0 0 1 21.485 12 59.768 59.768 0 0 1 3.27 20.875L5.999 12Zm0 0h7.5"
            />
          </svg>
        </.button>
      </.simple_form>
    </div>
    """
  end

  defp empty?(message), do: message in [nil, ""]

  def chat_input(assigns) do
    ~H"""
    <input
      phx-throttle="2000"
      type={@type}
      name={@field.name}
      id={@field.id}
      value={Phoenix.HTML.Form.normalize_value(@type, @field.value)}
      class={[
        "bg-neutral text-neutral-content border-none outline-none p-2",
        @class,
        @field.errors != [] && "input-error"
      ]}
    />
    """
  end

  def handle_event("sync_form", attrs, socket),
    do: {:noreply, assign(socket, :form, to_form(attrs))}

  def handle_event("send_message", %{"message" => ""}, socket), do: {:noreply, socket}

  def handle_event("send_message", %{"message" => message}, socket) do
    PubSub.broadcast(LiveChat.PubSub, socket.assigns.chat_id, {self(), message})
    {:noreply, assign(socket, :form, to_form(%{}))}
  end

  def handle_info(message, socket),
    do: {:noreply, update(socket, :messages, fn messages -> messages ++ [message] end)}

  def terminate(_reason, socket) do
    PubSub.unsubscribe(LiveChat.PubSub, socket.assigns.chat_id)
    {:noreply, socket}
  end
end
