defmodule AstraeaVirgoWeb.JudgementTypeController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Judgement Type API:
    - `GET /api/judgement-types`: get judgement types info
    - `GET /api/judgement-types/<judgement_type_id>` get the specified judgement type info
  """

  @doc """
  Get all judgement type info API

  API: GET /api/judgement-types

  Response: return 200, response `AstraeaVirgoWeb.JudgementTypeView.render/2` index.json
  """
  def index(conn, _params) do
    conn |>
      put_status(:ok) |>
      render(AstraeaVirgoWeb.JudgementTypeView, "index.json")
  end

  @doc """
  Get the specified judgement type info API

  API: GET /api/judgement-types/<judgement_type_id>

  Response:
    1. return 200, response `AstraeaVirgoWeb.JudgementTypeView.render/2` show.json
    2. return 400 when id is invalid, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def show(conn, %{"id" => id}) do
    cond do
      id in ["CE", "AC", "TLE", "RTE", "WA"] ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.JudgementTypeView, "show.json", type: id)
      true ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: %{"id" => ["is invalid. got:\"#{id}\""]})
    end
  end
end
