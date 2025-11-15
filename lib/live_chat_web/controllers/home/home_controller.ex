defmodule LiveChatWeb.HomeController do
  use LiveChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def redirect_to_chat(conn, %{"chat_id" => chat_id}) do
    redirect(conn, to: ~p"/chat/#{chat_id}")
  end
end
