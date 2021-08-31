defmodule AstraeaVirgoWeb.TokenController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Public Token API:
    - `POST /api/tokens`: request public token
  """

  defp random(code, 0), do: code
  defp random(code, n), do: random(Integer.to_string(:rand.uniform(10) - 1) <> code, n - 1)
  defp random(n), do: random("", n)

  @doc """
  Request a public token

  API: POST /api/tokens

  Request: `AstraeaVirgo.Validate.TokenCreateOperation`

  Response:
    1. return 201 when successfully created token, response `AstraeaVirgoWeb.TokenView.render/2` create.json
    2. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    3. return 500 when failed to generate token, response `AstraeaVirgoWeb.TokenView.render/2` generate_error.json
  """
  def create(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.TokenCreateOperation.run(params),
         {:ok, token, _claims} <- AstraeaVirgo.Token.get_public_token(params["email"], random(6)) do
      # TODO: send Email
      conn |>
        put_status(:created) |>
        render(AstraeaVirgoWeb.TokenView, "create.json", token: token)
    else
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.TokenView, "generate_error.json", reason: reason)
    end
  end

end
