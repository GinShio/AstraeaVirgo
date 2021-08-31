defmodule AstraeaVirgo.Validate.ContestSettingOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Setting Contest API
    - `POST /api/contests`

  Authorization: Bearer Token

  Permission: admin

  Request params: **application/json** Object

    | field       | type    | required | null | default | descript          |
    |-------------|---------|----------|------|---------|-------------------|
    | id          | ID      | no       | no   | ""      | 比赛 ID           |
    | name        | string  | yes      | no   |         | 比赛名称          |
    | formal_name | string  | no       | yes  | ""      | 比赛全称          |
    | public      | boolean | no       | no   | true    | 公开              |
    | anonymous   | boolean | no       | no   | true    | 匿名              |
    | start       | Time    | yes      | no   |         | 开始时间          |
    | duration    | Reltime | yes      | no   |         | 比赛时长          |
    | freeze      | Reltime | no       | yes  | 0       | 封榜时间          |
    | penalty     | integer | no       | yes  | 0       | 罚时 (单位: 分钟) |
    | logo        | File    | no       | yes  |         | LOGO              |
  """

  parameter "id", type: :string, required: false, default: ""
  parameter "name", type: :string, length: %{min: 1}
  parameter "formal_name", type: :string, required: false, allow_nil: true, default: ""
  parameter "public", type: :boolean, required: false, default: true
  parameter "anonymous", type: :boolean, required: false, default: true
  parameter "start", type: :string, func: &AstraeaVirgo.Validator.is_time/2
  parameter "duration", type: :integer, numericality: %{gt: 0}
  parameter "freeze", type: :integer, required: false, allow_nil: true, default: 0
  parameter "penalty", type: :integer, required: false, allow_nil: true, default: 0
  parameter "logo", type: :map,
    inner: %{
      "href" => [type: :string],
      "mime" => [type: :string, required: false, allow_nil: true]
    }, required: false, allow_nil: true, func: &AstraeaVirgo.Validator.is_file_type/2

  defp check_start(params) do
    if Timex.diff(Timex.parse!(params["start"], "{ISO:Extended}"), Timex.now(), :milliseconds) > 0 do
      {:ok, params}
    else
      {:error, {:validation, %{"start" => ["start time has passed."]}}}
    end
  end

  defp check_id(params) do
    with id when id !== "" <- params["id"],
         true <- AstraeaVirgo.Validator.is_id(id) do
      case AstraeaVirgo.Cache.Contest.exist?(id) do
        true -> {:ok, {:exist, params}}
        false -> {:ok, {:not_exist, params}}
      end
    else
      "" -> {:ok, {:not_exist, %{params | "id" => UUID.uuid4() |> UUID.uuid5(params["name"])}}}
      false -> {:error, {:validation, %{"id" => ["is not id."]}}}
    end
  end

  defp check_freeze(params) do
    cond do
      params["freeze"] < params["duration"] -> {:ok, params}
      true -> {:error, {:validation, %{"freeze" => ["greate than duration."]}}}
    end
  end

  def process(params) do
    with {:ok, _params} <- check_start(params),
         {:ok, _params} <- check_freeze(params),
         {:ok, params} <- check_id(params) do
      {:ok, params}
    else
      {:error, {:validation, _message}} = error -> error
    end
  end

end
