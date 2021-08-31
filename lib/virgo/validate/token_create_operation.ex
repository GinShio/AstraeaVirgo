defmodule AstraeaVirgo.Validate.TokenCreateOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Create Public Token API
    - `POST /api/tokens`

  Request params: **application/json** Object

    | field | type  | required | null | descript |
    |-------|-------|----------|------|----------|
    | email | Email | yes      | no   | Email    |
  """

  parameter "email", type: :string, func: &AstraeaVirgo.Validator.is_email/2

  def process(params), do: {:ok, params}

end
