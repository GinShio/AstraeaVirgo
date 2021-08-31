defmodule AstraeaVirgoWeb.SubmissionController do
  use AstraeaVirgoWeb, :controller

  @moduledoc """
  Impl Submission API without auth:
    - `GET /api/submissions`: get submissions info of specified user
    - `GET /api/submissions/<submission_id>`: get the specified submission info
    - `GET /api/submissions/<submission_id>/check`: check submission success

  Impl Submission API with user / contestant auth:
    - `POST /api/submissions`: submit code
    - `GET /api/submissions/<submissions_id>/detail`: get the specified submission detail
  """

  @doc """
  Get all submission info API

  API: GET /api/submissions

  Request: `AstraeaVirgo.Validate.SubmissionIndexOperation`

  Response:
    1. return 204 when no submission exists
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` index.json
    3. return 400 when user id not exists, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def index(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.SubmissionIndexOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Submission.index(params["user_id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, results} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.SubmissionView, "index.json", data: results)
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
  Get the specified submission info API

  API: GET /api/submissions/<submission_id>

  Response:
    1. return 204 when no submission exists
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` show.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def show(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.SubmissionPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Submission.show(params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.SubmissionView, "show.json", data: result)
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
  Get the specified submission detail API

  API: GET /api/submissions/<submission_id>/detail

  Response:
    1. return 204 when no submission exists
    2. return 200 when successfully get submission info, response `AstraeaVirgoWeb.SubmissionView.render/2` show.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 401 when user unauthorized, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    5. return 500 when server_error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def detail(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.SubmissionPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Judgement.show(params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, result} ->
        sub = conn |> Guardian.Plug.current_claims() |> Map.get("sub")
        case result.submitter do
          ^sub ->
            conn |>
              put_status(:ok) |>
              render(AstraeaVirgoWeb.SubmissionView, "detail.json", data: result)
          _ ->
            conn |>
              put_status(:unauthorized) |>
              render(AstraeaVirgoWeb.ErrorView, "unauthorized.json", reason: :submitter_inconsistent)
        end
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
  Create the submission API

  Request: `AstraeaVirgo.Validate.SubmissionCreateOperation`

  API: POST /api/submissions

  Response:
    1. return 201 when successfully create submission, response `AstraeaVirgoWeb.SubmissionView` create.json
    3. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    4. return 401 when user unauthorized, response `AstraeaVirgoWeb.ErrorView.render/2` unauthorized.json
    5. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def create(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.SubmissionCreateOperation.run(params),
         {:ok, problem} when not is_nil(problem) <- AstraeaVirgo.Cache.ProblemDetail.show(params["problem"]),
         {:ok, language} when not is_nil(language) <- AstraeaVirgo.Cache.Language.show(params["language"]),
         {:ok, snowflake} <- AstraeaVirgo.Snowflake.create() do
      {:"astraea.thrift.mq.SubmissinoInfo",
       snowflake,
       problem.id,
       language.id,
       language.extensions,
       params["code"],
       {:"astraea.thrift.mq.ProblemLimit",
        :undefined, # compilation_time
        problem.time_limit,
        language.time_multiplier,
        :undefined, # compilation_memory
        problem.memory_limit,
        language.mem_multiplier,
        :undefined, # compilation_output
        :undefined, # output
       },
       :undefined, # problem_testcase_last_update
       :undefined, # compilation_last_update
      } |>
        AstraeaVirgo.Thrift.Serialization.serialization(:submission_types, :"astraea.thrift.mq.SubmissinoInfo") |>
        AstraeaVirgo.MessageQueue.publish(language.id)
      conn |>
        put_status(:created) |>
        render(AstraeaVirgoWeb.SubmissionView, "create.json", submission_id: snowflake)
    else
      {:ok, nil} ->
        fields = %{"problem" => ["maybe not exists"], "language" => ["maybe not exists"]}
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, :backwards_clock} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :backwards_clock, reason: :backwards_clock)
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
  Check the submission API

  API: GET /api/submissions/<submission_id>/check

  Response:
    1. return 100 when submission pending, response nothing
    2. return 200 when submission finished, response nothing
    3. return 204 when submission not exists
    4. return 400 when request params is error, response `AstraeaVirgoWeb.ErrorView.render/2` validation.json
    5. return 500 when server error, response `AstraeaVirgoWeb.ErrorView.render/2` server_error.json
  """
  def check(conn, params) do
    with {:ok, _params} <- AstraeaVirgo.Validate.SubmissionPathOperation.run(params),
         {:ok, nil} <- AstraeaVirgo.Cache.Judgement.check(params["id"]) do
      conn |>
        put_status(:no_content) |>
        render(AstraeaVirgoWeb.GenericView, "empty.txt")
    else
      {:ok, :pending} ->
        conn |>
          put_status(:continue) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:ok, :finished} ->
        conn |>
          put_status(:ok) |>
          render(AstraeaVirgoWeb.GenericView, "empty.txt")
      {:error, {:validation, fields}} ->
        conn |>
          put_status(:bad_request) |>
          render(AstraeaVirgoWeb.ErrorView, "validation.json", fields: fields)
      {:error, :backwards_clock} ->
        conn |>
          put_status(:internal_server_error) |>
          render(AstraeaVirgoWeb.ErrorView, "server_error.json", type: :backwards_clock, reason: :backwards_clock)
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
