defmodule LiveChatWeb.HomeController do
  use LiveChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
