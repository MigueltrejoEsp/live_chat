defmodule LiveChatWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LiveChatWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="h-screen w-full max-w-screen-lg flex flex-col mx-auto bg-base-300 rounded-2xl">
      <header class="navbar bg-neutral text-neutral-content shadow-sm">
        <div class="flex-none">
          <button class="btn btn-square btn-ghost">
            <.icon name="hero-bars-3" />
          </button>
        </div>
        <div class="flex-1">
          <.link href={~p"/"} class="btn btn-ghost text-xl">Live Chat</.link>
        </div>
        <div class="flex-none gap-2">
          <.dropdown align="end">
            <div tabindex="0" class="w-32 flex flex-row justify-end">
              <button tabindex="0" class="btn btn-square btn-ghost">
                <.icon name="hero-ellipsis-horizontal" />
              </button>
            </div>
            <.menu
              tabindex="0"
              size="sm"
              class="dropdown-content bg-base-100 rounded-box z-[1] mt-3 w-32 p-2 shadow"
            >
              <:item :if={@current_scope}>
                <p>{@current_scope.user.email}</p>
              </:item>
              <:item :if={@current_scope}>
                <.link href={~p"/users/settings"}>Settings</.link>
              </:item>
              <:item :if={@current_scope}>
                <.link href={~p"/users/log-out"} method="delete">Log out</.link>
              </:item>
              <:item :if={!@current_scope}>
                <.link href={~p"/users/register"}>Register</.link>
              </:item>
              <:item :if={!@current_scope}>
                <.link href={~p"/users/log-in"}>Log in</.link>
              </:item>
            </.menu>
          </.dropdown>
        </div>
      </header>

      <main class="h-full">
        {render_slot(@inner_block)}
      </main>

      <.flash_group flash={@flash} />
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
