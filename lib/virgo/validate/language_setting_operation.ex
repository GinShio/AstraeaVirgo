defmodule AstraeaVirgo.Validate.LanguageSettingOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Setting Language API
    - `POST /api/languages`
    - `PUT /api/languages/<language_id>`

  Authorization: Bearer Token

  Permission: admin

  Request params: **application/json** Object

    | field           | type     | required     | defalut | descript                                       |
    |-----------------|----------|--------------|---------|------------------------------------------------|
    | id              | ID       | yes          |         |                                                |
    | name            | string   | yes          |         |                                                |
    | extensions      | string[] | yes          |         | language extension list, example ["cpp", "cc"] |
    | time_multiplier | double   | no           | 1.0     | ratio of language time to topic requirements   |
    | mem_multiplier  | double   | no           | 1.0     | ratio of language memory to topic requirements |
    | compile_script  | File     | yes (create) |         | 编译脚本                                       |
    | run_script      | File     | yes (create) |         | 编译脚本                                       |

  ## Multiplier Example
  The time required for the question is 1000 ms, time_multiplier is 2.0

  program takes 1800 ms, and the result is AC. it takes 2100 ms, the result is TLE.
  """

  parameter "id", type: :string, func: &AstraeaVirgo.Validator.is_id/2
  parameter "name", type: :string, length: %{min: 1}
  parameter "extensions", type: :list, length: %{min: 1}
  parameter "time_multiplier", type: :float, required: false, default: 1.000, numericality: %{gt: 0.0}
  parameter "mem_multiplier", type: :float, required: false, default: 1.000, numericality: %{gt: 0.0}
  parameter "compile_script", type: :map,
    inner: %{
      "href" => [type: :string],
      "mime" => [type: :string, required: false, allow_nil: true]
    }, required: false, allow_nil: true, func: &AstraeaVirgo.Validator.is_file_type/2
  parameter "run_script", type: :map,
    inner: %{
      "href" => [type: :string],
      "mime" => [type: :string, required: false, allow_nil: true]
    }, required: false, allow_nil: true, func: &AstraeaVirgo.Validator.is_file_type/2

  defp check_extensions(params) do
    extensions = for extension <- params["extensions"], reduce: [] do
      acc ->
        case extension do
          "" -> acc
          "." -> acc
          extension when is_binary(extension) ->
            with true <- extension =~ ~r/^.?[A-Za-z0-9]{1,5}$/,
                 false <- extension |> String.starts_with?(".") do
              [extension | acc]
            else
              false -> acc
              true -> [extension |> binary_part(1, byte_size(extension) - 1) | acc]
            end
          _ -> acc
        end
    end |> Enum.uniq()
    case extensions do
      [] -> {:error, {:validation, %{"extensions" => ["invalid."]}}}
      extensions -> {:ok, %{params | "extensions" => extensions}}
    end
  end

  def process(params) do
    case check_extensions(params) do
      {:ok, params} ->
        case AstraeaVirgo.Cache.Language.exist?(params["id"]) do
          true -> {:ok, {:exist, params}}
          false -> {:ok, {:not_exist, params}}
        end
      {:error, {:validation, _fields}} = reason -> reason
    end
  end

end
