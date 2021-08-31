defmodule AstraeaVirgo.Validate.UserCreateOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Register API
    - `POST /api/users`

  Authorized: Bearer Token

  Permission: public

  Request params: **application/json** Object

    | field    | type   | required | null | descript |
    |----------|--------|----------|------|----------|
    | email    | Email  | yes      | no   | 电子邮箱 |
    | username | ID     | yes      | no   | 用户名   |
    | password | SHA256 | yes      | no   | 密码     |
    | verify   | string | yes      | no   | 验证码   |
  """

  parameter "email", type: :string, func: &AstraeaVirgo.Validator.is_email/2
  parameter "username", type: :string, length: %{min: 1}
  parameter "password", type: :string, length: %{is: 64}, func: &AstraeaVirgo.Validator.is_hex/2
  parameter "verify", type: :string, length: %{is: 6}
  parameter "token", type: :string

  defp check(params) do
    # TODO: check username / email is unique
    {:ok, params}
  end

  def process(params)do
    with {:ok, _claims} <- AstraeaVirgo.Token.decode_and_verify(params["token"], %{}, secret: params["email"] <> params["verify"]),
         {:ok, _params} <- check(params) do
      {:ok, params}
    else
      {:error, reason} -> {:error, {:validation, %{"verify" => [reason]}}}
    end
  end

end
