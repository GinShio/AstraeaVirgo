defmodule AstraeaVirgo.Validate.SessionCreateOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Login API
    - `POST /api/sessions`

  Request params: **application/json** Object

    | field    | type       | required | null | descript |
    |----------|------------|----------|------|----------|
    | account  | Email / ID | yes      | no   | 账号     |
    | password | SHA256     | yes      | no   | 密码     |
  """

  parameter "account", type: :string, length: %{min: 1}
  parameter "password", type: :string, func: &AstraeaVirgo.Validator.is_hex/2

  defp authenticate?(account, password) do
    # TODO: auth check from db
    {:ok, "IQHV2FVS00", "solo"}
  end

  def process(params) do
    account = params["account"]
    password = params["password"]
    cond do
      not AstraeaVirgo.Validator.is_email(account) and not AstraeaVirgo.Validator.is_id(account) ->
        {:error, {:validation, %{"account" => ["is not email or id."]}}}
      byte_size(password) !== 64 ->
        {:error, {:validation, %{"password" => ["is not SHA256 string."]}}}
      true ->
        case authenticate?(account, password) do
          {:ok, id, perm} -> {:ok, params |> Map.put("id", id) |> Map.put("pem", perm)}
          error -> error
        end
    end
  end
end
