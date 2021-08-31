defmodule AstraeaVirgo.Validate.ContestPathOperation do
  use Exop.Operation

  @moduledoc """
  Validate the Path Variables of the Contest API

  Authorization: Bearer Token (if permission is admin)

  Request params: Path

    | field      | type | descript   |
    |------------|------|------------|
    | contest_id | ID   | contest ID |
  """

  parameter "contest_id", type: :string, func: &AstraeaVirgo.Validator.is_id/2

  def process(params) do
    now = Timex.now() |> DateTime.to_unix(:millisecond)
    case AstraeaVirgo.Cache.Contest.show(params["contest_id"]) do
      {:ok, nil} -> {:error, {:validation, %{"contest_id" => ["not exists."]}}}
      {:ok, data} ->
        now = now - (Timex.parse!(data.start_time, "{ISO:Extended}") |> DateTime.to_unix(:millisecond))
        duration = data.duration
        params = params |> Map.put("now", now) |> Map.put("duration", duration)
        cond do
          now <= 0 -> {:ok, {:not_start, params}}
          now > duration -> {:ok, {:expiration, params}}
          true -> {:ok, {:ok, params}}
        end
      error -> error
    end
  end

  def case_validation(validation, conn) do
    case validation do
      {:ok, {:not_start, _params}} ->
        {:responsed,
         conn |>
           Plug.Conn.put_status(:no_content) |>
           Elixir.Phoenix.Controller.render(AstraeaVirgoWeb.GenericView, "empty.txt")}
      {:ok, {:ok, params}} -> {:ok, params}
      {:ok, {:expiration, params}} ->
        if params["now"] - params["duration"] > 180000 do
          {:responsed,
           conn |>
             Plug.Conn.put_status(:no_content) |>
             Elixir.Phoenix.Controller.render(AstraeaVirgoWeb.GenericView, "empty.txt")}
        else
          {:ok, params}
        end
      error -> error
    end
  end

end
