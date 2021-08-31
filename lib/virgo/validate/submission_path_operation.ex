defmodule AstraeaVirgo.Validate.SubmissionPathOperation do
  use Exop.Operation

  @moduledoc """
  Validate the Path Variables of the Submission API
    - `GET /api/submissions/<submission_id>`
    - `GET /api/submissions/<submission_id>/detail` (permission: user / contestant)

  Request params: Path

    | field         | type | descript      |
    |---------------|------|---------------|
    | submission_id | ID   | submission ID |
  """

  parameter "submission_id", type: :string, from: "id", func: &AstraeaVirgo.Validator.is_snowflake/2

  def process(params), do: {:ok, params}

end
