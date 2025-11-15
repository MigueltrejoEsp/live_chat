defmodule LiveChatWeb.HomeHTML do
  @moduledoc """
  This module contains pages rendered by HomeController.
  """
  use LiveChatWeb, :html

  def home(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="h-full flex flex-col items-center justify-start gap-4 mx-auto mt-8 p-4 text-center">
        <h1 class="text-2xl font-bold">Welcome to Live Chat</h1>
        <p class="text-lg">
          This is a simple live chat application built with Phoenix.
        </p>

        <.form :let={_f} for={%{}} action={~p"/redirect-to-chat"} method="post">
          <input type="text" name="chat_id" placeholder="Enter chat room..." required />
          <button type="submit">Go to Chat</button>
        </.form>
      </div>
    </Layouts.app>
    """
  end
end
