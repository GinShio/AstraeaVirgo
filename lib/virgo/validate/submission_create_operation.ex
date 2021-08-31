defmodule AstraeaVirgo.Validate.SubmissionCreateOperation do
  use Exop.Operation

  @moduledoc """
  Validate Param for Create Submission API (submit code)
    - `POST /api/submissions`

  Permission: solo

  Request params: **application/json** Object

    | field    | type   | required | descript    |
    |----------|--------|----------|-------------|
    | problem  | ID     | yes      | Problem ID  |
    | language | ID     | yes      | Language ID |
    | code     | Base64 | yes      |             |
  """

  parameter "problem", type: :string, func: &AstraeaVirgo.Validator.is_id/2
  parameter "language", type: :string, func: &AstraeaVirgo.Validator.is_id/2
  parameter "code", type: :string, func: &AstraeaVirgo.Validator.is_base64/2

  def process(params), do: {:ok, params}

end
