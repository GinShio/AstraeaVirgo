defmodule AstraeaVirgo.Token.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  @moduledoc false

  @impl true
  def auth_error(conn, {type, reason}, _opts) do
    case type do
      :unauthenticated ->
        conn |>
          Plug.Conn.put_status(:unauthorized) |>
          Phoenix.Controller.render(AstraeaVirgoWeb.ErrorView, "unauthenticated.json")
      :unauthorized ->
        conn |>
          Plug.Conn.put_status(:unauthorized) |>
          Phoenix.Controller.render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: reason)
      :invalid_token ->
        conn |>
          Plug.Conn.put_status(:unauthorized) |>
          Phoenix.Controller.render(AstraeaVirgoWeb.ErrorView, "invalid_token.json")
      :no_resource_found ->
        conn |>
          Plug.Conn.put_status(:unauthorized) |>
          Phoenix.Controller.render(AstraeaVirgoWeb.ErrorView, "no_resource_found.json")
    end
  end
end
