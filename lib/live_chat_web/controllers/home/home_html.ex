defmodule LiveChatWeb.HomeHTML do
  @moduledoc """
  This module contains pages rendered by HomeController.
  """
  use LiveChatWeb, :html

  def home(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center h-screen gap-4">
      <h1 class="text-2xl font-bold">Welcome to Live Chat</h1>
      <p class="text-lg">
        This is a simple live chat application built with Phoenix.
      </p>
    </div>
    """
  end
end
