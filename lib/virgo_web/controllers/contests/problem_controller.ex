defmodule AstraeaVirgoWeb.Contests.ProblemController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Problem API without auth:
    - `GET /api/contests/<contest_id>/problems`: get problems info
    - `GET /api/contests/<contest_id>/problems/<problem_id>`: get the specified problem info
    - `GET /api/contests/<contest_id>/problems/<problem_id>/detail`: get the specified problem detail

  Impl Submission API with admin auth:
    - `POST /api/contests/<contest_id>/problems`: create problem
    - `PUT /api/contests/<contest_id>/problems/<problem_id>`: update problem
    - `DELETE /api/contests/<contest_id>/problems/<problem_id>`: delete problem
  """

  @doc """
  Get all problems info in contest API

  API: GET /api/contests/<contest_id>/problems

  Response:
    1. return 204 when no probelm exists
    2. return 200 when successfully get problems info, response `AstraeaVirgoWeb.ContestProblemView.render/2` index.json
    3. return 400 when contest not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
  """
  def index(conn, params) do
    with {:ok, {_, params}} <- AstraeaVirgo.Validate.ContestPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Contests.Problem.index(params["contest_id"]) do
        conn |>
          put_status(:no_content) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ContestProblemView, "index.json", data: results)
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
    end
  end

  @doc """
  Get the specified problem info in contest API

  API: GET /api/contests/<contest_id>/problems/<label>

  Response:
    1. return 204 when no problem exists
    2. return 200 when successfully get problem info, response `AstraeaVirgoWeb.ContestProblemView.render/2` show.json
    3. return 400 when contest not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    with {:ok, {_, params}} <- AstraeaVirgo.Validate.ContestPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Contests.Problem.show(params["contest_id"], params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ContestProblemView, "show.json", data: result)
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
    end
  end

  @doc """
  Get the specified problem detail in Contest API

  API: GET /api/contests/<contest_id>/problems/<label>/detail

  Response:
    1. return 204 when no problem exists
    2. return 200 when successfully get problem info, response `AstraeaVirgoWeb.ProblemView.render/2` detail.json
    3. return 400 when contest not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def detail(conn, params) do
    with {:ok, {_, params}} <- AstraeaVirgo.Validate.ContestPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Contests.Problem.show(params["contest_id"], params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.ProblemView, "detail.json", data: result.id |> AstraeaVirgo.Cache.ProblemDetail.show())
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {type, reason}} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: type, reason: reason)
      {:error, reason} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :internal, reason: reason)
    end
  end

end
